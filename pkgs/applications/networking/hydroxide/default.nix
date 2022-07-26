{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hc348rlwICnPWq7qYzFE01QeeJuQpSP19NjXtGqI10o=";
  };

  vendorSha256 = "sha256-M5QlhF2Cj1jn5NNiKj1Roh9+sNCWxQEb4vbtsDfapWY=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "A third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = platforms.unix;
  };
}
