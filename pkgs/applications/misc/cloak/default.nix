{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cloak";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "evansmurithi";
    repo = pname;
    rev = "v${version}";
    sha256 = "139z2ga0q7a0vwfnn5hpzsz5yrrrr7rgyd32yvfj5sxiywkmczs7";
  };

  cargoSha256 = "0af38wgwmsamnx63dwfm2nrkd8wmky3ai7zwy0knmifgkn4b7yyj";

  meta = with lib; {
    homepage = "https://github.com/evansmurithi/cloak";
    description = "Command-line OTP authenticator application";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
