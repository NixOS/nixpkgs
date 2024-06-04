{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.4-20231210.1";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-oC7TPq+Xsl960B7qJP81cWF+GGc28Miv4L8+1vWo7jA=";
  };

  vendorHash = "sha256-1i9v8Ej7TMIO+aMYFPFxdfD4b5j84/zkegaYb67WokU=";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
