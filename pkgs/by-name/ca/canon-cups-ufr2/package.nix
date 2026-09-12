{
  lib,
  stdenv,
  buildFHSEnv,
  writeTextFile,
  writeScript,
  fetchurl,
  unzip,
  autoconf,
  automake,
  libtool_1_5,
  makeWrapper,
  cups,
  jbigkit,
  libjpeg,
  libgcrypt,
  glib,
  gtk3,
  gdk-pixbuf,
  pango,
  cairo,
  atk,
  pkg-config,
  libxml2_13,
  libredirect,
  ghostscript,
  pkgs,
  zlib,
}:

let
  system =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "intel"
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "arm"
    else
      throw "Unsupported platform for Canon UFR2 Drivers: ${stdenv.hostPlatform.system}";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";
  libs = pkgs: lib.makeLibraryPath buildInputs;

  version = "6.20";
  dl = "8/0100007658/47";
  suffix1 = "m17n";
  suffix2 = "20";

  versionNoDots = builtins.replaceStrings [ "." ] [ "" ] version;
  src_canon = fetchurl {
    url = "https://gdlp01.c-wss.com/gds/${dl}/linux-UFRII-drv-v${versionNoDots}-${suffix1}-${suffix2}.tar.gz";
    hash = "sha256-6QJaaABubEaERpJxfVGxghB8yIb2pCaQZ6+VoqjmYrk=";
  };

  buildInputs = [
    cups
    zlib
    jbigkit
    libjpeg
    libgcrypt
    glib
    gtk3
    libxml2_13
    gdk-pixbuf
    pango
    cairo
    atk
  ];

  convertSpec = writeTextFile {
    name = "convert-spec.awk";
    checkPhase = "awk -f $target < /dev/null";
    text = ''
      $1 == "%" phase { inPhase = 1; next }
      inPhase && /^%/ { exit }

      inPhase {
        gsub("[$]{RPM_BUILD_DIR}", "$sourceRoot");
        gsub("[$]{RPM_BUILD_ROOT}", "");
        gsub("%{nobuild}", "0");
        gsub("%{_builddir}", "$sourceRoot");
        gsub("%{_prefix}", "$out");
        gsub("%{_libsarch}", "libs64/${system}");
        gsub("%{_libdir}", "$out/lib");
        gsub("%{locallibs}", "$out/lib");
        gsub("%{_bindir}", "$out/bin");
        gsub("%{_includedir}", "$out/include");
        gsub("%{_cflags}", "");
        gsub("%{_machine_type}", "MACHINETYPE=${stdenv.hostPlatform.parsed.cpu.name}");
        gsub("%{common_dir}", "cnrdrvcups-common-${version}");
        gsub("%{driver_dir}", "cnrdrvcups-lb-${version}");
        gsub("%{utility_dir}", "cnrdrvcups-utility-${version}");
        gsub("%{b_lib_dir}", "$sourceRoot/lib");
        gsub("%{b_include_dir}", "$sourceRoot/include");
        gsub("-m 4755", "-m 755"); # no setuid

        if (/%/) {
          print "error: variable not replaced:", $0 > "/dev/stderr"
          print "exit 1"
          exit 1
        }
        print
      }
    '';
  };
in
let
  driver = stdenv.mkDerivation rec {
    pname = "canon-cups-ufr2";
    inherit version;
    src = src_canon;

    # we can't let patchelf remove unnecessary RPATHs because the driver uses dlopen to load libjpeg and libgcrypt
    dontPatchELF = true;

    postUnpack = ''
      export sourceRoot=$PWD/$sourceRoot
      (
        cd $sourceRoot
        tar -xf Sources/cnrdrvcups-lb-${version}-1.${suffix2}.tar.xz
      )
    '';

    patches = [
      ./replace_incorrect_int_with_char.patch
    ];

    postPatch = ''
      substituteInPlace $(find cnrdrvcups-lb-${version}/cngplp -name Makefile.am) \
        --replace-quiet /usr/include/libxml2/ ${libxml2_13.dev}/include/libxml2/

      substituteInPlace \
        cnrdrvcups-common-${version}/{{backend,cngplp/src,rasterfilter}/Makefile.am,rasterfilter/cnrasterproc.h} \
        cnrdrvcups-lb-${version}/{cngplp/files,pdftocpca}/Makefile.am \
        --replace-fail /usr "$out"

      substituteInPlace cnrdrvcups-common-${version}/cngplp/Makefile.am \
        --replace-fail etc/cngplp "$out/etc/cngplp"

      patchShebangs cnrdrvcups-common-${version} cnrdrvcups-lb-${version}
    '';

    nativeBuildInputs = [
      makeWrapper
      unzip
      autoconf
      automake
      libtool_1_5
      pkg-config
    ];

    inherit buildInputs;

    configureScript = writeScript "canon-cups-ufr2-configure" ''
      set -eu
      # Update old automake files
      for dir in \
        cnrdrvcups-common-${version}/{backend,buftool,cngplp,cnjbig,rasterfilter} \
        cnrdrvcups-lb-${version}/{cngplp/files,cngplp,cpca,pdftocpca}
      do
        echo autoreconf $dir
        pushd "$dir"
        # For some reason, autoreconf fails to create ltmain.sh on first run.
        autoreconf --force --install --warnings=none || autoreconf --force --install --warnings=none
        popd
      done

      awk -f ${convertSpec} -v phase=setup cnrdrvcups-lb.spec | bash -eux
    '';

    buildPhase = ''
      runHook preBuild

      awk -f ${convertSpec} -v phase=build cnrdrvcups-lb.spec | bash -eux

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      awk -f ${convertSpec} -v phase=install cnrdrvcups-lb.spec | bash -eux

      (
        cd $out/lib

        patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib:$out/lib" libcanonufr2r.so.1.0.0
        patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib" libcaepcmufr2.so.1.0
        patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib" libColorGearCufr2.so.2.0.0
        wrapProgram $out/lib/cups/filter/rastertoufr2 \
          --prefix PATH ":" "$out/bin" \
          --prefix LD_LIBRARY_PATH ":" "$out/lib" \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set NIX_REDIRECTS /usr/bin=$out/bin:/usr/share=$out/share:/etc/cngplp2=$out/etc/cngplp2:/usr/local/canon/lib/profiles=$out/share/caepcm/ufr2
      )

      (
        cd $out/bin
        patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib" cnsetuputil2 cnpdfdrv
        patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib:$out/lib" cnpkbidir cnrsdrvufr2 cnpkmoduleufr2r cnjbigufr2

        wrapProgram $out/bin/cnpkbidir \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set NIX_REDIRECTS /usr/share/cnpkbidir=$out/share/cnpkbidir


        wrapProgram $out/bin/cnsetuputil2 \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set NIX_REDIRECTS /usr/share/cnsetuputil2=$out/usr/share/cnsetuputil2
      )

      makeWrapper "${ghostscript}/bin/gs" "$out/bin/gs" \
        --prefix LD_LIBRARY_PATH ":" "$out/lib" \
        --prefix PATH ":" "$out/bin"

      runHook postInstall
    '';

    meta = {
      description = "CUPS Linux drivers for Canon printers";
      homepage = "http://www.canon.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [
        lluchs
        lqr471814
      ];
    };
  };
in
buildFHSEnv {
  pname = "canon-cups-ufr2";
  version = version;
  executableName = "canon-cups-ufr2-fhs";
  nativeBuildInputs = [ makeWrapper ];

  # cnrsdrvufr2 and the proprietary helpers it starts are not all part of
  # the source tree we build above.  In particular, some of them use raw
  # execve(2) calls with FHS paths, so libredirect cannot make them work.
  # Put the complete driver closure in the FHS environment and provide the
  # paths those binaries expect there.
  targetPkgs =
    fhsPkgs:
    let
      inherit (fhsPkgs)
        cups
        zlib
        jbigkit
        libjpeg
        libgcrypt
        glib
        gtk3
        libxml2_13
        gdk-pixbuf
        pango
        cairo
        atk
        ;
    in
    [
      cups
      zlib
      jbigkit
      libjpeg
      libgcrypt
      glib
      gtk3
      libxml2_13
      gdk-pixbuf
      pango
      cairo
      atk
    ];
  extraBuildCommands = ''
    mkdir -p $out/usr/bin $out/usr/share $out/etc $out/usr/local/canon/lib
    ln -s ${driver}/bin/cnjbigufr2 $out/usr/bin/cnjbigufr2
    ln -s ${driver}/bin/cnpkmoduleufr2r $out/usr/bin/cnpkmoduleufr2r
  '';

  # buildFHSEnv normally replaces /etc with a private tmpfs.  The CUPS filter
  # passes its live PPD to cnrsdrvufr2 via a path below /etc/cups, so expose
  # that directory inside the FHS namespace as well.
  extraBwrapArgs = [ "--ro-bind-try /etc/cups /etc/cups" ];

  # The FHS wrapper is also used as the implementation for every driver
  # entry point that CUPS or another helper may invoke directly.
  runScript = "${stdenv.shell} -c 'command=\"$1\"; shift; exec \"$command\" \"$@\"' --";
  extraInstallCommands = ''
    cp -a ${driver}/. $out/
    chmod -R u+w $out

    for binary in cnpkmoduleufr2r cnjbigufr2; do
      rm -f $out/bin/$binary
      makeWrapper $out/bin/canon-cups-ufr2-fhs $out/bin/$binary \
        --add-flags ${driver}/bin/$binary
    done
    rm -f $out/lib/cups/filter/rastertoufr2
    makeWrapper $out/bin/canon-cups-ufr2-fhs $out/lib/cups/filter/rastertoufr2 \
      --add-flags ${driver}/lib/cups/filter/rastertoufr2
  '';

  meta = driver.meta // {
    description = "CUPS Linux drivers for Canon printers (FHS runtime)";
  };
}
