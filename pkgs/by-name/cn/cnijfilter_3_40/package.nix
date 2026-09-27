{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  cups,
  popt,
  libpng,
  libtiff,
  gtk2,
  ghostscript,
  patchelf,
}:

/*
  Canon's own Linux CUPS driver, built from Canon's official source
  release. Modeled directly on nixpkgs' existing cnijfilter_2_80 /
  cnijfilter_4_00 packages: cnijfilter versions are named after the
  source drop, not a single printer, because one tarball's
  `ppd`/`cnijfilter` components support several models selected via
  --program-suffix. This version (3.40-1) covers the MP250, MP280,
  MP495, MG5100, MG5200, iP4800, MG6100 and MG8100 series -- notably
  it's what makes the MP280 usable, since Gutenprint's generic driver
  produces washed-out colors on it and the real color-management
  logic (libcnbpcmcm, prebuilt binary blob, no source available) only
  ships inside this driver.

  Important note about versions: like cnijfilter_2_80/cnijfilter_4_00,
  the version indicates which printers are supported, not a normal
  upstream release train. This package should not be "upgraded" in
  the usual way -- a newer source drop supporting different printers
  should be added as a separate `cnijfilter_X_YY` package instead.
*/
stdenv.mkDerivation {
  pname = "cnijfilter";
  version = "3.40";

  src = fetchurl {
    url = "https://gdlp01.c-wss.com/gds/0/0100003020/01/cnijfilter-source-3.40-1.tar.gz";
    sha256 = "0ylapgzwrc51vlilmw4zv210ws049745rqsf7v68m7hs975d8pd9";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # Fixes `configure`/autoconf/automake macros for modern autotools
    # (the upstream release ships 2010-era generated files that no
    # longer regenerate cleanly).
    ./patches/configure-fixes.patch
    # Adapts the CUPS backend/filter code to newer libcups APIs.
    ./patches/cups-fixes.patch
    # Adds the Quality/Density/Contrast/RenderIntent/Grayscale/Cartridge
    # PPD options for the MP280 specifically (only the model the
    # patch author owns and could test); from
    # https://aur.archlinux.org/packages/cnijfilter-mp280 (Arch's
    # per-model package built from the same upstream source). Other
    # supported models don't get the same PPD tuning yet -- adding it
    # for them is a good follow-up contribution for owners of those
    # printers.
    ./patches/cn-ppd-support-mp280.patch
    # Fixes a boolean PPD option that upstream's cngrayscale handling
    # gets wrong.
    ./patches/cngrayscale-boolean-fix.patch
    # Fixes deprecated glibc APIs removed by modern glibc versions.
    ./patches/glibc-deprecated-fix.patch
    # Miscellaneous fixes for compiling this 2010-era source with a
    # modern GCC/toolchain.
    ./patches/compilation-fixes-2024-11-06.diff
    # cnijfilter/src/bjfimage.c accesses png_ptr->jmpbuf directly,
    # which libpng >= 1.5 made opaque; use the png_jmpbuf() accessor
    # macro instead. Same fix as nixpkgs' cnijfilter_2_80
    # (patches/libpng15.patch).
    ./patches/libpng15-jmpbuf.patch
  ];

  postPatch = ''
    # These two backend dirs hardcode /usr/lib/cups/backend rather than
    # following --prefix.
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backend/src/Makefile.am
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backendnet/backend/Makefile.am

    # Same story for the BSCC network-config lookup path.
    sed -i "s|/usr/lib/bjlib/|$out/lib/bjlib/|" backend/src/cnij_backend_common.c

    # cngpij shells out to a hardcoded /usr/bin/lpr.
    sed -i "s|/usr/bin/lpr|${cups}/bin/lpr|" cngpij/cngpij/bjcups.c

    # pstocanonij shells out to gs (via a "GS_PATH"/"GS_BIN" #define pair)
    # to rasterize embedded images -- also hardcoded to /usr/bin.
    sed -i 's|#define GS_PATH\s*"/usr/bin"|#define GS_PATH "${ghostscript}/bin"|' \
      pstocanonij/filter/pstocanonij.c
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    cups
    popt
    libpng
    libtiff
    gtk2
  ];

  # This is 2010-era C; modern GCC's default C standard chokes on it.
  env.NIX_CFLAGS_COMPILE = "-std=gnu90";

  # This source ships its own top-level Makefile that just loops `make`
  # over a fixed dir list (including components we deliberately don't
  # build, like the ink-monitor GUI tools) -- genericBuild's default
  # build/install phases would invoke it, so build/install every
  # component explicitly instead and never touch that top-level Makefile.
  dontBuild = true;

  configurePhase = ''
    runHook preConfigure

    ( cd libs && ./autogen.sh --prefix=$out )
    ( cd cngpij && ./autogen.sh --prefix=$out --enable-progpath=$out/bin )
    ( cd pstocanonij && ./autogen.sh --prefix=$out --enable-progpath=$out/bin )
    ( cd backend && ./autogen.sh --prefix=$out )
    ( cd backendnet && ./autogen.sh --prefix=$out )

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model

    for d in libs cngpij pstocanonij backend backendnet; do
      make -C "$d"
      make -C "$d" install
    done

    # ppd/ and cnijfilter/ are rebuilt once per supported model, selected
    # by --program-suffix (each pass produces a differently-named
    # ppd/binary, e.g. cifmp280 + canonmp280.ppd).
    for pr in mp250 mp280 mp495 mg5100 mg5200 ip4800 mg6100 mg8100; do
      ( cd ppd
        ./autogen.sh --prefix=$out --program-suffix=$pr
        make clean
        make
        make install )

      ( cd cnijfilter
        # --enable-libpath is supposed to bake this path in via
        # AC_DEFINE_UNQUOTED(XBJLIBPATH, ...) + config.h, but modern
        # autoheader doesn't generate a template for this codebase's
        # legacy acconfig.h-based defines, so config.h ends up empty and
        # XBJLIBPATH is left as a literal, unexpanded macro name at
        # runtime ("Error: invalid printer model name", since it can't
        # find its own cif<model>.conf). Define it directly as a
        # compiler flag instead, which doesn't depend on autoheader.
        #
        # The path itself must be /var/lib/cups/path/lib/bjlib, NOT
        # $out/lib/bjlib: some fixed-size stack buffer in this 2010-era
        # code overflows on a full Nix store path (~68 chars vs. the
        # ~15-char "/usr/lib/bjlib" it was sized for), corrupting the
        # stack (observed smashing %rbp with path bytes) and crashing
        # with SIGBUS inside libcnbpess's BJESExpire at end of job.
        # /var/lib/cups/path is a short, stable symlink NixOS's cups
        # module already maintains into the merged driver environment
        # (see nixpkgs' cnijfilter_2_80/cnijfilter_4_00, which use the
        # same path for the same reason).
        ./autogen.sh --prefix=$out --program-suffix=$pr \
          --enable-libpath=/var/lib/cups/path/lib/bjlib --enable-binpath=$out/bin \
          CPPFLAGS="-DXBJLIBPATH=/var/lib/cups/path/lib/bjlib"
        make clean
        make
        make install )
    done

    # Per-model color/paper/quality database and Canon's proprietary
    # color-management shared libraries (prebuilt, no source), one set
    # per model directory: 356=mp250 369=mp495 370=mp280 373=mg5100
    # 374=mg5200 375=ip4800 376=mg6100 377=mg8100.
    mkdir -p $out/lib/bjlib
    for pr_id in 356 369 370 373 374 375 376 377; do
      install -m444 "$pr_id"/database/* $out/lib/bjlib/
      install -m755 "$pr_id"/libs_bin64/*.so.* $out/lib/
    done
    install -m755 com/libs_bin64/*.so.* $out/lib/

    # Those libraries load each other by soname at runtime; give them an
    # rpath pointing at their siblings and the unsuffixed symlink each
    # expects to dlopen.
    (
      cd $out/lib
      for so_file in *.so.*; do
        ln -s "$so_file" "''${so_file%.so.*}.so"
        patchelf --set-rpath $out/lib "$so_file"
      done
    )

    install -Dm444 LICENSE-cnijfilter-3.40EN.txt \
      $out/share/licenses/cnijfilter/LICENSE-cnijfilter-3.40EN.txt

    runHook postInstall
  '';

  # nixpkgs' cnijfilter_2_80 disables the standard autoPatchelf/shrink-rpath
  # pass here for the same reason: some of these libraries dlopen each
  # other without listing it in DT_NEEDED, and shrink-rpath would strip
  # the very rpath entries that make that work.
  dontPatchELF = true;

  # Fortify hardening crashes this filter at print time -- see
  # https://github.com/NixOS/nixpkgs/issues/276125 (same crash, same
  # driver family, hit on cnijfilter_2_80).
  hardeningDisable = [ "fortify3" ];

  meta = {
    description = "Canon InkJet printer drivers for the MP250, MP280, MP495, MG5100, MG5200, iP4800, MG6100 and MG8100 series";
    homepage = "http://support-au.canon.com.au/contents/AU/EN/0100302002.html";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ rclement ];
  };
}
