{
  lib,
  stdenv,
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
  libxml2,
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

  version = "6.00";
  dl = "0/0100009240/34";
  suffix1 = "m17n";
  suffix2 = "00";

  versionNoDots = builtins.replaceStrings [ "." ] [ "" ] version;
  src_canon = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/${dl}/linux-UFRII-drv-v${versionNoDots}-${suffix1}-${suffix2}.tar.gz";
    hash = "sha256-JQAe/avYG+9TAsH26UGai6u8/upRXwZrGBc/hd4jZe8=";
  };

  buildInputs = [
    cups
    zlib
    jbigkit
    libjpeg
    libgcrypt
    glib
    gtk3
    libxml2
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
stdenv.mkDerivation rec {
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
      --replace-quiet /usr/include/libxml2/ ${libxml2.dev}/include/libxml2/

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
    )

    (
      cd $out/bin
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib" cnsetuputil2 cnpdfdrv
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${lib.getLib stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib:$out/lib" cnpkbidir cnrsdrvufr2 cnpkmoduleufr2r cnjbigufr2

      wrapProgram $out/bin/cnrsdrvufr2 \
        --prefix LD_LIBRARY_PATH ":" "$out/lib" \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /usr/bin/cnpkmoduleufr2r=$out/bin/cnpkmoduleufr2r:/usr/bin/cnjbigufr2=$out/bin/cnjbigufr2

      wrapProgram $out/bin/cnsetuputil2 \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /usr/share/cnsetuputil2=$out/usr/share/cnsetuputil2
    )

    makeWrapper "${ghostscript}/bin/gs" "$out/bin/gs" \
      --prefix LD_LIBRARY_PATH ":" "$out/lib" \
      --prefix PATH ":" "$out/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "CUPS Linux drivers for Canon printers";
    homepage = "http://www.canon.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lluchs ];
  };
}
