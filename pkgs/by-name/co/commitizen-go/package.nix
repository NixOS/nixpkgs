{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "commitizen-go";
  version = "1.0.3";

  # we can't obtain the commit hash when using fetchFromGithub
  commit_revision = "unspecified (nix build)";

  src = fetchFromGitHub {
    owner = "lintingzhen";
    repo = "commitizen-go";
    rev = "v${version}";
    hash = "sha256-pAWdIQ3icXEv79s+sUVhQclsNcZg+PTZZ6I6JPo7pNg=";
  };

  vendorHash = "sha256-TbrgKE7P3c0gkqJPDkbchWTPkOuTaTAWd8wDcpffcCc=";

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  ldflags = [
    "-X 'github.com/lintingzhen/commitizen-go/cmd.revision=${commit_revision}'"
    "-X 'github.com/lintingzhen/commitizen-go/cmd.version=${version}'"
  ];

  meta = with lib; {
    description = "Command line utility to standardize git commit messages, golang version";
    homepage = "https://github.com/lintingzhen/commitizen-go";
    license = licenses.mit;
    maintainers = with maintainers; [ seanrmurphy ];
    mainProgram = "commitizen-go";
  };
}
