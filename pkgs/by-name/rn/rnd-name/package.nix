{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:
let
  version = "1.0.0";
in
buildGoModule {
  inherit version;
  pname = "rnd-name";

  src = fetchFromGitHub {
    owner = "mrhenry";
    repo = "rnd-name";
    rev = "v${version}";
    hash = "sha256-o3A7VDH6rpJmCBu8ZPfPllMm1rAN1tNrz2eUyd2Tjjs=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "rnd-name";
    description = "Random strings that are easy to recognize";
    homepage = "https://github.com/mrhenry/rnd-name";
    changelog = "https://github.com/mrhenry/rnd-name/releases/tag/v${version}";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ fd ];
  };
}
