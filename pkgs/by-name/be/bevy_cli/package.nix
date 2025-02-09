{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "bevy_cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    # the rust workspace includes multiple crates, including
    #
    # - bevy_cli, which is the main CLI that hosts all subcommand
    # - bevy_lint, which is just the linter part of the main CLI
    #
    # currently, only the linter has been released, but the main CLI also
    # already exposes it and will be the goto-tool in the future
    rev = "lint-v${version}";
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
