{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "reviewdog";
    repo = "reviewdog";
    rev = "v${version}";
    hash = "sha256-VYhn98tDyUS2HNd7sEJD/M8kln9/AMeGxm84SxSSOy8=";
  };

  vendorHash = "sha256-V4hL4PHtpLV6SHg7sCbs5tHIEuosRMr7jynTFdD1eZ8=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/reviewdog/reviewdog/commands.Version=${version}"
  ];

  meta = {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    mainProgram = "reviewdog";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${version}/CHANGELOG.md";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
