{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.25";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-2ydYGuIcoxw9iBSeCg3q6gVW2yMqL8j3nRzlplIm8Ps=";
  };

  vendorHash = "sha256-zyjtiZzePqWtxqkHqdNp04g70V42Rkrf60V7BY8JMz4=";

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
