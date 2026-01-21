{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "blobtools";
  version = "0-unstable-2012-10-24";

  src = fetchFromGitHub {
    owner = "AndroidRoot";
    repo = "BlobTools";
    rev = "6186e33baa10ce6f1c738d7b91eb5153743105af";
    hash = "sha256-zg0A5Dm3255jqcioK45P2uzDnaaSAUkl4WtCJh77IuQ=";
  };

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 {blobpack,blobunpack} -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/AndroidRoot/BlobTools";
    description = "Tools for modifiying ASUS Transformer firmware";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "blobpack";
  };
}
