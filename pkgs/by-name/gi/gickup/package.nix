{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.27";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-ExSTvIq5u5Zmep/tipAJOHcXMxtESLQlEVMWnD8/rSI=";
  };

  vendorHash = "sha256-riRFDhVOMdqwgGd6wowSDNgt8lZPzagCvKPWTHSqm6U=";

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
