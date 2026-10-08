{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reviewdog";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "reviewdog";
    repo = "reviewdog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NEnYaHUC7a4ylKvyZ6iAXjLKeEICki/0ro9rhhLoXZs=";
  };

  vendorHash = "sha256-k5dLFgYOgwlMUnk1Xb7lyewT9lXdAoCj1HNxshSVE9M=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/reviewdog/reviewdog/commands.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    mainProgram = "reviewdog";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
})
