{
  lib,
  stdenv,
  substitute,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "libamplsolver";
  version = "20211109";

  src = fetchurl {
    url = "https://ampl.com/netlib/ampl/solvers.tgz";
    sha256 = "sha256-LVmScuIvxmZzywPSBl9T9YcUBJP7UFAa3eWs9r4q3JM=";
  };

  patches = [
    (substitute {
      src = ./libamplsolver-sharedlib.patch;
      substitutions = [
        "--replace"
        "@sharedlibext@"
        "${stdenv.hostPlatform.extensions.sharedLibrary}"
      ];
    })
  ];

  # Allow install_name_tool rewrite paths on darwin.
  #   error: install_name_tool: changing install names or rpaths can't be redone for: /nix/store/...-libamplsolver-.../lib/libamplsolver.dylib (for architecture arm64) because larger updated load commands do not fit (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  installPhase = ''
    runHook preInstall
    pushd sys.$(uname -m).$(uname -s)
    install -D -m 0644 *.h -t $out/include
    install -D -m 0644 *${stdenv.hostPlatform.extensions.sharedLibrary}* -t $out/lib
    install -D -m 0644 *.a -t $out/lib
    popd
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libamplsolver.dylib $out/lib/libamplsolver.dylib
  ''
  + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Library of routines that help solvers work with AMPL";
    homepage = "https://ampl.com/netlib/ampl/";
    license = [ licenses.mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
    # generates header at compile time
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
