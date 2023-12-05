{ fetchFromGitHub, lib, nix-update-script, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "sway-overfocus";
  version = "0.2.3-fix";

  src = fetchFromGitHub {
    owner = "korreman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KHbYlxgrrZdNKJ7R9iVflbbP1c6qohM/NHBSYuzxEt4=";
  };

  cargoHash = "sha256-zp6PSu8P+ZUhrqi5Vxpe+z9zBaSkdVQBMGNP0FVOviQ=";

  # Crate without tests.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = ''"Better" focus navigation for sway and i3.'';
    homepage = "https://github.com/korreman/sway-overfocus";
    changelog = "https://github.com/korreman/sway-overfocus/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.ivan770 ];
    mainProgram = "sway-overfocus";
  };
}

