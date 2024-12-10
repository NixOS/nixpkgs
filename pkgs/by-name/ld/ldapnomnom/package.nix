{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "ldapnomnom";
    rev = "refs/tags/v${version}";
    hash = "sha256-JYpwk7ShLH9fPTFYzLecD+iPekFMnHOlzusizCYo8dA=";
  };

  vendorHash = "sha256-lm801UM7JOYsGRe92FErY2jonrqRRjLKojN5YyytqvY=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    changelog = "https://github.com/lkarlslund/ldapnomnom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldapnomnom";
  };
}
