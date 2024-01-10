{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.24";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-c7IP5jYP8DbJkQEHmU2cMgClLqmMTAJkPCCHbdW5yLw=";
  };

  vendorHash = "sha256-fqtZL3Tr9QTFRUsczs11Y3b127CqoYkHV+dPI+vYpDk=";

  ldflags = ["-X main.version=${version}"];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "gickup";
    license = lib.licenses.asl20;
  };
}
