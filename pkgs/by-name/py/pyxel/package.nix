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
  version = "2.8.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitao";
    repo = "pyxel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+SitYe2HFA6rwqk5lipcKFdBy69zdAhw3Q+Nb0iBx6s=";
  };

  patches = [
    (fetchpatch {
      name = "add-Cargo.lock.patch";
      url = "https://github.com/kitao/pyxel/commit/821286112ea0c26141aa64b25aaa076611a2a91d.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-XtFdtmprPKrdjFOzEsNMJjc4PpNv6KDtWX2Hes2IKe0=";
    })
  ];

  cargoRoot = "crates";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      patches
      pname
      version
      cargoRoot
      ;
    hash = "sha256-SGrQmGZeM2NcooDqCTO2HOXgLg7h+VvDIierDacqSFs=";
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
