{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unzip,
}:

buildGoModule rec {
  pname = "pzip";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ybirader";
    repo = "pzip";
    rev = "v${version}";
    hash = "sha256-bb2TSSyA7TwgoV53M/7WkNcTq8F0EjCA7ObHfnGL9l0=";
  };

  vendorHash = "sha256-MRZlv4eN1Qbu+QXr//YexTDYSK4pCXAPO7VvGqZhjho=";

  nativeBuildInputs = [
    unzip
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A fast concurrent zip archiver and extractor";
    homepage = "https://github.com/ybirader/pzip";
    changelog = "https://github.com/ybirader/pzip/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "pzip";
  };
}
