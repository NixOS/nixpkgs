{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "bit";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "chriswalz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-85GEx9y8r9Fjgfcwh1Bi8WDqBm6KF7uidutlF77my60=";
  };

  vendorSha256 = "sha256-3Y/B14xX5jaoL44rq9+Nn4niGViLPPXBa8WcJgTvYTA=";

  propagatedBuildInputs = [ git ];

  # Tests require a repository
  doCheck = false;

  meta = with lib; {
    description = "Command-line tool for git";
    homepage = "https://github.com/chriswalz/bit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
