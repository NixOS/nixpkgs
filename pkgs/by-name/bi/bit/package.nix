{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "bit";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "chriswalz";
    repo = "bit";
    rev = "v${version}";
    sha256 = "sha256-18R0JGbG5QBDghF4SyhXaKe9UY5UzF7Ap0Y061Z1SZ8=";
  };

  vendorHash = "sha256-3Y/B14xX5jaoL44rq9+Nn4niGViLPPXBa8WcJgTvYTA=";

  propagatedBuildInputs = [ git ];

  # Tests require a repository
  doCheck = false;

  meta = with lib; {
    description = "Command-line tool for git";
    homepage = "https://github.com/chriswalz/bit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "bit";
  };
}
