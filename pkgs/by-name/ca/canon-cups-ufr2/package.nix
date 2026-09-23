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
  targetPkgs = fhsPkgs: [
    driver
    fhsPkgs.stdenv.cc.libc
    fhsPkgs.cups
    fhsPkgs.zlib
    fhsPkgs.jbigkit
    fhsPkgs.libjpeg
    fhsPkgs.libgcrypt
    fhsPkgs.glib
    fhsPkgs.gtk3
    fhsPkgs.libxml2_13
    fhsPkgs.gdk-pixbuf
    fhsPkgs.pango
    fhsPkgs.cairo
    fhsPkgs.atk
  ];
  extraBuildCommands = ''
    mkdir -p $out/usr/local/canon/lib
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

    for binary in ${driver}/bin/* ${driver}/lib/cups/filter/* ${driver}/lib/cups/backend/*; do
      local dest="$out/bin/$(basename $binary)"
      rm -f $dest
      makeWrapper $out/bin/canon-cups-ufr2-fhs $dest \
        --add-flags $binary
    done
  '';

  meta = driver.meta // {
    description = "CUPS Linux drivers for Canon printers (FHS runtime)";
  };
}
