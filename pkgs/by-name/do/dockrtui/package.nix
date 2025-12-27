{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "dockrtui";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "LuuNa-JD";
    repo = "dockrtui";
    rev = "v${version}";
    hash = "sha256-C0TS3jp3ONsgjXKZYeMM9AeIxT2Moy8gxhFxkguT1I8=";
  };

  cargoHash = "sha256-8DY4pRWCswsC+wkrAHFic7YTkAT2VMRk8++jpNoQkEs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A fast, modern and keyboard-driven terminal dashboard for Docker";
    homepage = "https://github.com/LuuNa-JD/dockrtui";
    changelog = "https://github.com/LuuNa-JD/dockrtui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chansuke ];
    mainProgram = "dockrtui";
  };
}
