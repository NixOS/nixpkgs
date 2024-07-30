{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

buildGoModule rec {
  pname = "git-spice";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    rev = "refs/tags/v${version}";
    hash = "sha256-BYIq+12piA0WgfwVSB6P6CKC81icAY/P4/pv2ZMj5N8=";
  };

  vendorHash = "sha256-AIqy0OQsYRStbFLv2L8m4R0k1tr5fVM1FeMFn90yFoY=";

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
