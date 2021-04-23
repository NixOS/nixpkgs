{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "bit";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "chriswalz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-juQAFVqs0d4EtoX24EyrlKd2qRRseP+jKfM0ymkD39E=";
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
