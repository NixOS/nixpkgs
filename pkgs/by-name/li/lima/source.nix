{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.1.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-U054xA3utBcSfpyvsZi4MvgJGNa7QyAYJf9usNXpgXg=";
  };

  vendorHash = "sha256-C4YCuFVXkL5vS6lWZCGkEeZQgAkP55buPDGZ/wvMnAA=";

  meta = {
    homepage = "https://github.com/lima-vm/lima";
    changelog = "https://github.com/lima-vm/lima/releases/tag/v${version}";
    knownVulnerabilities = lib.optional (lib.versionOlder version "2") "Lima version ${version} is EOL. See https://lima-vm.io/docs/releases/.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anhduy
    ];
  };
}
