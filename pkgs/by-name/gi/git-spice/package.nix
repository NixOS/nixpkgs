{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "git-spice";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    rev = "refs/tags/v${version}";
    hash = "sha256-VODBN+3xDa+sGynhnWnnhPy0VEKPWOQeh2Ge75OTS0A=";
  };

  vendorHash = "sha256-irYXuh0KmCmeZ2fKNduu7zpVqDQmmR7H2bNTMa2zOjI=";

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
