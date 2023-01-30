{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.1-20221109.1";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-MlbzPZuEOhb3wJMXWkrt6DK8z0MPgznSm0N9Y6vJVWY=";
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
