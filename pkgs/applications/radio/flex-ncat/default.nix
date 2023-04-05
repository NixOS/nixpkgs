{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.2-20230126.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-2taQQVTgAFyqtS06zZ+4Qmr/JIqU6mxNQYvxt+L/Mtc=";
  };

  vendorHash = "sha256-Tv6sbfWNOHYwA7v1SpNeM9aHs+3DSFv4V4qxllxrzJc=";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
