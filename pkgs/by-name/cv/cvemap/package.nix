{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cvemap";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cvemap";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ste08J3KIJmugKZegU82wq6N+B5DaHc8Z0UtqKsUYE8=";
  };

  vendorHash = "sha256-+gYJkKJLUsCbh0JhVNOdr8U5pgWYjD56KZ0VePoYecU=";

  subPackages = [
    "cmd/cvemap/"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to work with CVEs";
    homepage = "https://github.com/projectdiscovery/cvemap";
    changelog = "https://github.com/projectdiscovery/cvemap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cvemap";
  };
}
