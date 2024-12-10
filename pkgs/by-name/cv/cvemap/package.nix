{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cvemap";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cvemap";
    rev = "refs/tags/v${version}";
    hash = "sha256-aeUYcgBTHWWLTuAXnnc73yXaC3yLZzruqvedUYCnht4=";
  };

  vendorHash = "sha256-VQGWi01mOP2N4oYsaDK7wn/+hSFEDHhSma9DOZ06Z3k=";

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
