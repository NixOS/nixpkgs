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
  xorg,
  stdenv,
  libglvnd,
  libxcb,
  libxkbcommon,
  enableWayland ? stdenv.hostPlatform.isLinux,
  versionCheckHook,
  wayland,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "simplemoji";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "simplemoji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f6KwfcYNLceRFFoR0NzrVl0fcXvhRb3HPNgRTfYWns8=";
  };

  cargoHash = "sha256-MZ04Y5BaJYkDzcOQZrskH/ddq/wjhdZ0gMDmifL98Eg=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m141-0.88.0";
          hash = "sha256-CB7zRtAQ2KNak6YZB+5kAN/nkmou+mJM/pK/skN9Fqk=";
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
    xorg.libX11
    rustPlatform.bindgenHook
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath (
        [
          libglvnd
          libxkbcommon
          xorg.libXcursor
          xorg.libXext
          xorg.libXrandr
          xorg.libXi
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
