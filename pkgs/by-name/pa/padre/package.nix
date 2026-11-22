{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "padre";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "glebarez";
    repo = "padre";
    tag = "v${version}";
    hash = "sha256-UkL0EydwQfZl4HVtXiU8AyLJnzqBwECIgwm3bpQvyes=";
  };

  vendorHash = "sha256-BBDGnz8u2FEKwuTP9DKz6FoODaW4+VFcL36lumoYTb8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Advanced exploiting tool for Padding Oracle attacks against CBC mode encryption";
    homepage = "https://github.com/glebarez/padre";
    changelog = "https://github.com/glebarez/padre/releases/tag/v${version}";
    # https://github.com/glebarez/padre/issues/28
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "padre";
  };
}
