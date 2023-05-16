{ lib
, testers
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, libsamplerate
, swig
, alsa-lib
, AppKit
, CoreFoundation
, Security
, python3
, pythonSupport ? true
, runCommand
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pjsip";
<<<<<<< HEAD
  version = "2.13.1";
=======
  version = "2.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = "pjproject";
<<<<<<< HEAD
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-R1iKIkWyNCRV2PjQgTqKmJYUgHAZrREanD60Jz6MY1Y=";
=======
    rev = finalAttrs.version;
    sha256 = "sha256-yzszmm3uIyXtYFgZtUP3iswLx4u/8UbFt80Ln25ToFE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./fix-aarch64.patch
<<<<<<< HEAD
=======
    (fetchpatch {
      name = "CVE-2022-23537.patch";
      url = "https://github.com/pjsip/pjproject/commit/d8440f4d711a654b511f50f79c0445b26f9dd1e1.patch";
      sha256 = "sha256-7ueQCHIiJ7MLaWtR4+GmBc/oKaP+jmEajVnEYqiwLRA=";
    })
    (fetchpatch {
      name = "CVE-2022-23547.patch";
      url = "https://github.com/pjsip/pjproject/commit/bc4812d31a67d5e2f973fbfaf950d6118226cf36.patch";
      sha256 = "sha256-bpc8e8VAQpfyl5PX96G++6fzkFpw3Or1PJKNPKl7N5k=";
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs =
    lib.optionals pythonSupport [ swig python3 ];

  buildInputs = [ openssl libsamplerate ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optionals stdenv.isDarwin [ AppKit CoreFoundation Security ];

  preConfigure = ''
    export LD=$CC
  '';

  NIX_CFLAGS_LINK = lib.optionalString stdenv.isDarwin "-headerpad_max_install_names";

  postBuild = lib.optionalString pythonSupport ''
    make -C pjsip-apps/src/swig/python
  '';

  configureFlags = [ "--enable-shared" ];

  outputs = [ "out" ]
    ++ lib.optional pythonSupport "py";

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${finalAttrs.pname}-${finalAttrs.version}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${finalAttrs.pname}-${finalAttrs.version}/samples
  '' + lib.optionalString pythonSupport ''
    (cd pjsip-apps/src/swig/python && \
      python setup.py install --prefix=$py
    )
  '' + lib.optionalString stdenv.isDarwin ''
    # On MacOS relative paths are used to refer to libraries. All libraries use
    # a relative path like ../lib/*.dylib or ../../lib/*.dylib. We need to
    # rewrite these to use absolute ones.

    # First, find all libraries (and their symlinks) in our outputs to define
    # the install_name_tool -change arguments we should pass.
    readarray -t libraries < <(
      for outputName in $(getAllOutputNames); do
        find "''${!outputName}" \( -name '*.dylib*' -o -name '*.so*' \)
      done
    )

    # Determine the install_name_tool -change arguments that are going to be
    # applied to all libraries.
    change_args=()
    for lib in "''${libraries[@]}"; do
      lib_name="$(basename $lib)"
      change_args+=(-change ../lib/$lib_name $lib)
      change_args+=(-change ../../lib/$lib_name $lib)
    done

    # Rewrite id and library refences for all non-symlinked libraries.
    for lib in "''${libraries[@]}"; do
      if [ -f "$lib" ]; then
        install_name_tool -id $lib "''${change_args[@]}" $lib
      fi
    done

    # Rewrite library references for all executables.
    find "$out" -executable -type f | while read executable; do
      install_name_tool "''${change_args[@]}" "$executable"
    done
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "pjsua --version";
  };

<<<<<<< HEAD
  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
=======
  passthru.tests.pkg-config = testers.hasPkgConfigModule {
    package = finalAttrs.finalPackage;
    moduleName = "libpjproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.tests.python-pjsua2 = runCommand "python-pjsua2" { } ''
    ${(python3.withPackages (pkgs: [ pkgs.pjsua2 ])).interpreter} -c "import pjsua2" > $out
  '';

  meta = with lib; {
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    mainProgram = "pjsua";
    platforms = platforms.linux ++ platforms.darwin;
<<<<<<< HEAD
    pkgConfigModules = [
      "libpjproject"
    ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
