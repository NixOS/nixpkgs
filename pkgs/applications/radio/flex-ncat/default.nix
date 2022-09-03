{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.1-20220505.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-Jqoqy+W5sKfg7U/F2OpK1jAVM8rm1Tbr4RHG/mMVE0g=";
  };

  vendorSha256 = "sha256-mWZRaPbmSPBUhTCWSkU33zOOq79ylEbnjPG3gLkWeQY=";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
