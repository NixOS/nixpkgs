{
  lib,
  stdenv,
  substitute,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libamplsolver";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ampl";
    repo = "asl";
    rootDir = "src/solvers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D1hB5z6r4n6+u1oWclhIst1mXDvObmOsh1j0uocairQ=";
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

  preConfigure = ''
    chmod u+x configure configurehere
  '';

  env = {
    # For non-trapping FP architectures like loongarch64 and riscv64
    NIX_CFLAGS_COMPILE = lib.optionalString (
      stdenv.hostPlatform.isRiscV64 || stdenv.hostPlatform.isLoongArch64
    ) "-DNO_fpu_control";
    # Allow install_name_tool rewrite paths on darwin.
    #   error: install_name_tool: changing install names or rpaths can't be redone for: /nix/store/...-libamplsolver-.../lib/libamplsolver.dylib (for architecture arm64) because larger updated load commands do not fit (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";
  };

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

  meta = {
    description = "Library of routines that help solvers work with AMPL";
    homepage = "https://ampl.com/netlib/ampl/";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aanderse ];
    # generates header at compile time
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
