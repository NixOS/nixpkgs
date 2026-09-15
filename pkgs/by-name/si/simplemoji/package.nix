{
  lib,
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  linkFarm,
  fetchgit,
  runCommand,
  gn,
  libiconv,
  ninja,
  nix-update-script,
  makeWrapper,
  pkg-config,
  python3,
  removeReferencesTo,
  cctools,
  fontconfig,
  stdenv,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxi,
  libxkbcommon,
  libxrandr,
  enableWayland ? stdenv.hostPlatform.isLinux,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "simplemoji";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "simplemoji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-51/eBJXmx+QC0uKP7dzB6OUErPtdL+CxV3As0hh3h/E=";
  };

  cargoHash = "sha256-AZOnHghxhZgmjkL8W7wm7qC4zpJ/3HvyaItScAeVVdo=";

  env = {
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

    SKIA_GN_COMMAND = "${gn}/bin/gn";
    SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3 # skia
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    cctools.libtool
  ];

  buildInputs = [
    libxcb
    fontconfig
    libx11
    rustPlatform.bindgenHook
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath (
        [
          libglvnd
          libxkbcommon
          libxcursor
          libxext
          libxrandr
          libxi
        ]
        ++ lib.optionals enableWayland [ wayland ]
      );
    in
    ''
      # library skia embeds the path to its sources
      remove-references-to -t "$SKIA_SOURCE_DIR" \
        $out/bin/simplemoji

      wrapProgram $out/bin/simplemoji \
        --prefix LD_LIBRARY_PATH : ${libPath}
    '';

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast Application for look your amazing emojis written in Rust";
    mainProgram = "simplemoji";
    homepage = "https://github.com/SergioRibera/simplemoji";
    changelog = "https://github.com/SergioRibera/simplemoji/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sergioribera
    ];
  };
})
