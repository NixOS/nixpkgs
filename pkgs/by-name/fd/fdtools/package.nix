{
  stdenv,
  lib,
  fetchurl,
  skawarePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdtools";
  version = "2024.12.07";

  src = fetchurl {
    url = "https://code.dogmap.org/fdtools/releases/fdtools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-URK5FBpCbhcp2haug0lWtc9wOvwJHPTWZe4u8HDeaYc=";
  };

  patches = [
    ./add-skalibs-include.patch
  ];

  outputs = [
    "bin"
    "lib"
    "dev"
    "man"
    "doc"
    "out"
  ];

  buildInputs = [
    skawarePackages.skalibs
  ];

  configurePhase = ''
    cd fdtools-${finalAttrs.version}
    substituteInPlace conf-compile/defaults/host_compile.sh \
      --replace-fail "gcc" "$CC"
    substituteInPlace conf-compile/defaults/host_link.sh \
      --replace-fail "gcc" "$CC"
    echo "${skawarePackages.skalibs.lib}/lib/skalibs/sysdeps" > conf-compile/defaults/depend_skalibs_sysdeps
  '';

  buildPhase = ''
    bash package/build
  '';

  # gcc15
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  installPhase = ''
    mkdir -p $bin/bin
    tools=( grabconsole multitee pipecycle recvfd seek0 sendfd setblock setstate statfile vc-get vc-lock vc-switch )

    for t in "''${tools[@]}"; do
      mv "command/$t" "$bin/bin/$t"
    done

    mkdir -p $lib/lib
    mkdir -p $dev/include
    mkdir -p $man/share/man/man1
    mkdir -p $man/share/man/man8
    docdir=$doc/share/doc/fdtools
    mkdir -p $docdir

    mv library/fdtools.a $lib/lib/fdtools.a
    mv include/fdtools.h $dev/include/fdtools.h
    mv man/man1/* $man/share/man/man1/
    mv man/man8/* $man/share/man/man8/

    ${
      skawarePackages.cleanPackaging.commonFileActions {
        noiseFiles = [
          "conf-compile/**/*"
          "src/**/*"
          "src/.**/*"
          "compile/**/*"
          "package/{build,check,compile,elsewhere,install,install_commands,own,run,sharing,upgrade,upgrade_version,url_src,url_src_latest,versions}"
        ];
        docFiles = [
          "package/INSTALL"
          "package/LICENSE"
          "package/README"
        ];
      }
    } $docdir

    ${skawarePackages.cleanPackaging.checkForRemainingFiles}

    # we don’t use this, but nixpkgs requires it
    touch $out
  '';

  meta = {
    homepage = "https://code.dogmap.org/fdtools/";
    description = "Set of utilities for working with file descriptors";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
