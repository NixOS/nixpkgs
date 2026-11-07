{
  lib,
  fetchFromGitHub,
}:

let
  version = "2.3.0";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${version}";
    hash = "sha256-SZweWHyzBL1A0ouvNzGFyYYp465f1/4GT6lBNmIH9MM=";
  };

  vendorHash = "sha256-eDw0ouubM0EqKXq6977fx61kTT9P4zSmRBnmkpMQAXI=";

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
