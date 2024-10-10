{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "git-spice";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    rev = "refs/tags/v${version}";
    hash = "sha256-ap0ZGRDdHQMVYSk9J8vsZNpvaAwpHFmPT5REiCxYepQ=";
  };

  vendorHash = "sha256-YJ8OxmonnxNu4W17tD1Z7K625LCINlh6ZgoxOpmtNC0=";

  subPackages = [ "." ];

  nativeCheckInputs = [ git ];

  buildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage stacked Git branches";
    homepage = "https://abhinav.github.io/git-spice/";
    changelog = "https://github.com/abhinav/git-spice/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "gs";
  };
}
