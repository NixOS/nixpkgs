{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.2.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-2cqfQIB9FpI/PicH7P9fhtqHCnWosvWB3t2M+A2HhoA=";
  };

  vendorHash = "sha256-/6UZst+H/D0Dw1q/YTUZMN1jhCkZI1/vKuGQgrgy808=";

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
