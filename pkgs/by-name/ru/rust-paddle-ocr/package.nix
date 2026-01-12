{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-paddle-ocr";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "zibo-chen";
    repo = "rust-paddle-ocr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sDr7oTt9m02u52tuZzuSqKO8s4rIdhMRirzif8Lp2+g=";
  };

  cargoHash = "sha256-fNtKnAPcJrjnbl7wqn+iDmf/HRQzex1oCfY3h11rrSM=";

  buildFeatures = [ "v5" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and efficient OCR";
    homepage = "https://github.com/zibo-chen/rust-paddle-ocr";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "ocr";
  };
})
