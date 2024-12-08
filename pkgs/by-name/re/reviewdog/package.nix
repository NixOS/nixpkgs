{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B0gu6vhbnhMx2CNQzQlIIwsycBup6bnmAk/1C6F/AWE=";
  };

  vendorHash = "sha256-k7o2r9CQNDVGgCGoYZ02nK443eolN+UGdEp2ItEkURg=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [ "-s" "-w" "-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    mainProgram = "reviewdog";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${version}/CHANGELOG.md";
    maintainers = [ ];
    license = licenses.mit;
  };
}
