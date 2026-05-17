{
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  removeReferencesTo,
  dbus,
  fontconfig,
  libxkbcommon,
  lib,
  gn,
  ninja,
  linkFarm,
  fetchgit,
  runCommand,
}:
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "spell-cli";
  version = "0-unstable-2026-05-17";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vimyoung";
    repo = "spell";
    rev = "97d643605eab510a60cce8bf2310afa25c2d41a6";
    hash = "sha256-W6zvIBqglrU+H+nFRztv6uP4XOqarrl7LhUxkrAvJE0=";
  };

  cargoHash = "sha256-lXAwef5zc69+R+t2QrxzHORZEB+sglu1fgK+4Ly4MJg=";

  cargoBuildFlags = [
    "--package"
    "spell-cli"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
    python3 # skia
    removeReferencesTo
  ];

  buildInputs = [
    dbus
    fontconfig
    libxkbcommon
    rustPlatform.bindgenHook
  ];

  env = {
    SKIA_GN_COMMAND = lib.getExe gn;
    SKIA_NINJA_COMMAND = lib.getExe ninja;

    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m142-0.89.1";
          hash = "sha256-J7mBQ124/dODxX6MsuMW1NHizCMATAqdSzwxpP2afgk=";
        };

        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';
  };

  postFixup = ''
    # library skia embeds the path to its sources
    remove-references-to -t "$SKIA_SOURCE_DIR" \
      $out/bin/sp
  '';

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];

  meta = {
    description = "Make desktop widgets by the mystic arts of Spell !!";
    homepage = "https://vimyoung.github.io/Spell/";
    changelog = "${finalAttrs.src.meta.homepage}/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "sp";
    maintainers = with lib.maintainers; [ onatustun ];
  };
})
