{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reviewdog";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "reviewdog";
    repo = "reviewdog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7ZlS8kDJyis0sUWPTanTyIJaz4hNhJ3bnawRKQQJejg=";
  };

  vendorHash = "sha256-tDfM0A0CTuquBJLv703LRZ5NhgBcwbgXA5tHhXDsgYI=";

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
