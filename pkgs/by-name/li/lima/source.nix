{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.1.3";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-7hr89PApcxi/qoYZK8xPuGbhG95RfiYjkyVvZYIflyw=";
  };

  vendorHash = "sha256-8AksUgle1SlWuALi553TlpZ2qwO+jMA1kZQke91fimU=";

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
