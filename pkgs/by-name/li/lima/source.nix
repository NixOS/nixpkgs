{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.0.3";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-NoHNmJ6z7eZTzjl8ps3wFY2e68FcoBsu5ZhE0NXt95g=";
  };

  vendorHash = "sha256-SeLYVQI+ZIbR9qVaNyF89VUvXdfv1M5iM+Cbas6e2E0=";

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
