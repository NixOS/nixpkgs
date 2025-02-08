{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "bevy_cli";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    rev = "lint-${version}";
    hash = "sha256-WjsShx7zvJENo4xRKnb0dwjfzzcvKyjQamH98owdo3A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TNw2GsGgqYBMlbIniqerB8YnDyrv/kn9omR+N/4o0Bs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Utility and management tool for bevy projects";
    homepage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      robwalt
    ];
    mainProgram = "bevy";
    platforms = lib.platforms.all;
  };
}
