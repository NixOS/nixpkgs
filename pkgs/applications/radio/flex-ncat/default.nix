{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.1-20221007.1";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-9rxI3wsqjhaH7DD1Go/8s0r6jXaE15Z9PPtbsnsfrM0=";
  };

  vendorSha256 = "sha256-lnJtFixgv4ke4Knavb+XKFPzHCiAPhNtfZS3SRVvY2g=";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
