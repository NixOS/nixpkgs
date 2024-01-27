{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.26";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-GYYmoGNYiwarMZw1w8tdH8zKl19XQ2R+EaJFK8iacwI=";
  };

  vendorHash = "sha256-vyDzGho9vcdCmBP7keccp5w3tXWHlSaFoncS1hqnBoc=";

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
