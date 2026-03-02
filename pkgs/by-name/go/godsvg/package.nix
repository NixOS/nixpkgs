{
  godot_4_6,
  makeWrapper,
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "godsvg";
  version = "1.0-alpha14";
  src = fetchFromGitHub {
    owner = "MewPurPur";
    repo = "GodSVG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bo45Zu13RRPxf5tZhCxAulTe61o9kwqX1nEFJDaeBng=";
  };

  nativeBuildInputs = [
    godot_4_6
    makeWrapper
  ];

  buildPhase =
    let
      # https://github.com/MewPurPur/GodSVG/blob/main/export_presets.cfg
      preset =
        {
          "x86_64-linux" = "Linux";
          "aarch64-darwin" = "macOS";
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    ''
      runHook preBuild

      # Cannot create file `/homeless-shelter/.config/godot_4_5/projects/...`
      export HOME=$TMPDIR
      # Link the export-templates to the expected location. The `--export` option expects the templates in the home directory.
      mkdir -p $HOME/.local/share/godot_4_5
      ln -s ${godot_4_6}/share/godot_4_5/templates $HOME/.local/share/godot_4_5

      godot4 --headless --export-pack ${preset} godsvg.pck

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -Dm444 godsvg.pck $out/share/godsvg/godsvg.pck

    makeWrapper ${godot_4_6}/bin/godot4 $out/bin/godsvg \
    --add-flag "--main-pack" \
    --add-flag "$out/share/godsvg/godsvg.pck"

    install -Dm444 ./assets/logos/icon.svg $out/share/icons/hicolor/scalable/apps/godsvg.svg
    install -Dm444 ./assets/logos/icon.png $out/share/icons/hicolor/256x256/apps/godsvg.png
    install -Dm444 ./assets/GodSVG.desktop $out/share/applications/GodSVG.desktop

    runHook postInstall
  '';

  # currently, all tags are marked as pre-release
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    homepage = "https://www.godsvg.com/";
    description = "A vector graphics application for structured SVG editing";
    changelog = "https://www.godsvg.com/article/${lib.replaceString "." "-" finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "godsvg";
    maintainers = [ lib.maintainers.mochienya ];
  };
})
