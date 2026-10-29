{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reviewdog";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "reviewdog";
    repo = "reviewdog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9yrQyP72CpjJ0VBtnVtQzl3asJ2TP2xAFSXL+i80/QM=";
  };

  vendorHash = "sha256-Zj3xWj7Gbz5HUiXr+eSeXLnAoNfxyXuw8J0TRaCYnHU=";

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
