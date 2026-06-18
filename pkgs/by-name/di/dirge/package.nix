{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gcc,
  binutils,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dirge";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dirge-code";
    repo = "dirge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ctUTeJr+M9RrWIlRyVqPtcAeaLVOU9/0CaoYi+DLKNs=";
  };

  cargoHash = "sha256-/pux5r91yR22zAnb0VTnWQV98hBj3rMhFhddN+vh5dw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    gcc
    binutils
  ];

  buildInputs = [
    sqlite
  ];

  # needs both of the following to compile
  RUSTFLAGS = "-C linker=${gcc}/bin/gcc";
  doCheck = false;

  __structuredAttrs = true;

  meta = {
    description = "Dynamic Intent Resolution Grounding Engine";
    homepage = "https://github.com/dirge-code/dirge";
    changelog = "https://github.com/dirge-code/dirge/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "dirge";
  };
})
