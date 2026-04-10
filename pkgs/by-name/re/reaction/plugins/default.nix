{
  lib,
  rustPlatform,
  callPackage,
  reaction,
}:
{
  # NOTE: plugins are binaries, so no special integration with the derivation is required
  # mkReactionPlugin is meant for only official plugins living in the reaction source tree
  mkReactionPlugin =
    name: extra:
    rustPlatform.buildRustPackage (
      {
        pname = name;
        inherit (reaction) version src cargoHash;
        buildAndTestSubdir = "plugins/${name}";

        meta = {
          changelog = "https://framagit.org/ppom/reaction/-/releases/v${reaction.version}";
          description = "Official reaction plugin ${name}";
          homepage = "https://framagit.org/ppom/reaction";
          license = lib.licenses.agpl3Plus;
          mainProgram = name;
          maintainers = with lib.maintainers; [ ppom ];
          platforms = lib.platforms.unix;
          teams = [ lib.teams.ngi ];
        };
      }
      // extra
    );

  # capture all plugins except default.nix (this file)
  plugins = lib.removeAttrs (lib.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./.;
  }) [ "default" ];
}
