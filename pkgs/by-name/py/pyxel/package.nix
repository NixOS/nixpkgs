{
  lib,
  python3Packages,
  cargo,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  rustc,
  SDL2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyxel";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitao";
    repo = "pyxel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oQtHcws7vUM4ZIiVeN7H6+TCeHuCwzGzhjtiXwEN1w0=";
  };

  cargoRoot = "crates";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      pname
      version
      cargoRoot
      ;
    hash = "sha256-q4lL3PtELEHkNbycxzjm6VbDrTWCHsXTzDghpuvtMTk=";
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

  preBuild = ''
    # logic taken from Makefile
    cp LICENSE README.md python/pyxel/
  '';

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
