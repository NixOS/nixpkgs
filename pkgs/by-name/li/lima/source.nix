{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.2.0";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-4Wi+YzMdEN263jeBefEvizlF2k+nLVq3+AHyqagUeHw=";
  };

  vendorHash = "sha256-gD9C0kupcEWCsU0nYOg+VcBCWR0oRf6Gaw0DDn0xits=";

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
