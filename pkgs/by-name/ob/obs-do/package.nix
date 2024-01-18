{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-do";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    rev = "refs/tags/v${version}";
    hash = "sha256-MlBtnRMovnek4dkfO7ocafSgAwIXB5p1FmhNeqfSspA=";
  };

  cargoHash = "sha256-5EqiDibeWrN45guneN2bxKDXfSz3wDxBNHdl0Km/lpA=";

  meta = with lib; {
    description = "CLI for common OBS operations while streaming using WebSocket";
    homepage = "https://github.com/jonhoo/obs-do";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "obs-do";
  };
}
