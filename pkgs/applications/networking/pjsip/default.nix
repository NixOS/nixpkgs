{ lib
, testers
, stdenv
, fetchFromGitHub
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
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = "pjproject";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-R1iKIkWyNCRV2PjQgTqKmJYUgHAZrREanD60Jz6MY1Y=";
  };

  patches = [
    ./fix-aarch64.patch
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

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
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
    pkgConfigModules = [
      "libpjproject"
    ];
  };
})
