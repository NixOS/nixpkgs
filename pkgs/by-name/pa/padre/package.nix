{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "padre";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "glebarez";
    repo = "padre";
    rev = "refs/tags/v${version}";
    hash = "sha256-UkL0EydwQfZl4HVtXiU8AyLJnzqBwECIgwm3bpQvyes=";
  };

  vendorHash = "sha256-BBDGnz8u2FEKwuTP9DKz6FoODaW4+VFcL36lumoYTb8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Advanced exploiting tool for Padding Oracle attacks against CBC mode encryption";
    homepage = "https://github.com/glebarez/padre";
    changelog = "https://github.com/glebarez/padre/releases/tag/v${version}";
    # https://github.com/glebarez/padre/issues/28
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "padre";
  };
}
