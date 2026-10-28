{
  lib,
  stdenv,
  fetchFromGitHub,
  cctools,
  fixDarwinDylibNames,
  darwin,
  replaceVars,
  buildPackages,
  binutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lp_solve";
  version = "5.5.2.14";

  src = fetchFromGitHub {
    owner = "lp-solve";
    repo = "lp_solve";
    tag = finalAttrs.version;
    hash = "sha256-mCYstt0vEGZk7rjcXmxqZjYTviF8xfg1mvA4jqKCYgE=";
  };

  nativeBuildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      binutils
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      fixDarwinDylibNames
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      darwin.autoSignDarwinBinariesHook
    ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int";
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
    NIX_LDFLAGS = "-headerpad_max_install_names";
  };

  dontConfigure = true;

  patches = [
    (replaceVars ./0001-fix-cross-compilation.patch {
      emulator = "${stdenv.hostPlatform.emulator buildPackages}";
    })
  ];

  buildPhase =
    let
      ccc = if stdenv.hostPlatform.isDarwin then "ccc.osx" else "ccc";
    in
    ''
      runHook preBuild

      (cd lpsolve55 && bash -x -e ${ccc})
      (cd lp_solve  && bash -x -e ${ccc})

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -d -m755 $out/bin $out/lib $out/include/lpsolve
    install -m755 lp_solve/bin/*/lp_solve -t $out/bin
    install -m644 lpsolve55/bin/*/liblpsolve* -t $out/lib
    install -m644 lp_*.h -t $out/include/lpsolve

    rm $out/lib/liblpsolve*.a
    rm $out/include/lpsolve/lp_solveDLL.h  # A Windows header

    runHook postInstall
  '';

  meta = {
    description = "Mixed Integer Linear Programming (MILP) solver";
    mainProgram = "lp_solve";
    homepage = "https://github.com/lp-solve/lp_solve";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.unix;
  };
})
