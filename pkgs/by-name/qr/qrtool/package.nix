{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "qrtool";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    rev = "v${version}";
    sha256 = "sha256-FoWUGhNfVILpYxmsnSzRIM1+R9/xFxCF7W1sdiHaAiA=";
  };

  cargoSha256 = "sha256-mtejnHCkN2krgFAneyyBpvbv5PZO3GigM2DJqrbHim4=";

  meta = with lib; {
    maintainers = with maintainers; [ philiptaron ];
    description = "An utility for encoding or decoding QR code";
    license = licenses.asl20;
    homepage = "https://sorairolake.github.io/qrtool/book/index.html";
    changelog = "https://sorairolake.github.io/qrtool/book/changelog.html";
    mainProgram = "qrtool";
  };
}
