{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QodwSirWCMQqimzUEcpH7lnCc2k4WIZiqww+kqI1zoU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TxYLfTw/CpU+bFfXYCpRfSk7b/aSNkcUvNaA1EGIFGc=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      unlicense
    ];
    maintainers = with maintainers; [
      figsoda
      gepbird
    ];
    mainProgram = "hck";
  };
}
