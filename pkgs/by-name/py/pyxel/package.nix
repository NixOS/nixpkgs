{
  lib,
  python3Packages,
  cargo,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  SDL2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyxel";
  version = "2.8.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitao";
    repo = "pyxel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+SitYe2HFA6rwqk5lipcKFdBy69zdAhw3Q+Nb0iBx6s=";
  };

  postPatch = ''
    cp ${./Cargo.lock} crates/Cargo.lock
    chmod u+w crates/Cargo.lock
  '';

  cargoRoot = "crates";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      pname
      version
      cargoRoot
      ;
    postPatch = ''
      cp ${./Cargo.lock} crates/Cargo.lock
    '';
    hash = "sha256-UEN66yygcyOJt8fROClfBi1V5F7/I7P4j4vkPzKJ7jY=";
  };

  buildAndTestSubdir = "python";

  maturinBuildFlags = [
    "--features"
    "sdl2_dynamic"
  ];

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [ SDL2 ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  # Tests want to use the display
  doCheck = false;

  pythonImportsCheck = [
    "pyxel"
    "pyxel.pyxel_binding"
  ];

  meta = {
    changelog = "https://github.com/kitao/pyxel/tree/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Retro game engine for Python";
    homepage = "https://github.com/kitao/pyxel";
    license = lib.licenses.mit;
    mainProgram = "pyxel";
    maintainers = with lib.maintainers; [
      tomasajt
      miniharinn
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
