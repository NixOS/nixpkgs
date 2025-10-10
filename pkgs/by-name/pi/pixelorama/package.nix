{
  lib,
  stdenv,
  fetchFromGitHub,
  godot_4_4,
  nix-update-script,
}:

let
  presets = {
    "i686-linux" = "Linux 32-bit";
    "x86_64-linux" = "Linux 64-bit";
    "aarch64-linux" = "Linux ARM64";
  };
  preset =
    presets.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  godot = godot_4_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pixelorama";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Orama-Interactive";
    repo = "Pixelorama";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5ODSGZM39FO+6tTLoosnrf5ngh+fSHpNsphTgjlux48=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    godot
  ];

  # Pixelorama is tightly coupled to the version of Godot that it is meant to be built with,
  # and Godot does not follow semver, they break things in minor releases.
  preConfigure = ''
    godot_ver="${lib.versions.majorMinor godot.version}"
    godot_expected=$(sed -n -E 's@config/features=PackedStringArray\("([0-9]+\.[0-9]+)"\)@\1@p' project.godot)
    [ "$godot_ver" == "$godot_expected" ] || {
      echo "Expected Godot version: $godot_expected; found: $godot_ver" >&2
      exit 1
    }
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "${godot.export-template}"/share/godot/export_templates "$HOME"/.local/share/godot/
    mkdir -p build
    godot4 --headless --export-release "${preset}" ./build/pixelorama

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/pixelorama
    install -D -m 644 -t $out/libexec ./build/pixelorama.pck
    install -D -m 644 -t $out/share/applications ./Misc/Linux/com.orama_interactive.Pixelorama.desktop
    install -D -m 644 -T ./assets/graphics/icons/icon.png $out/share/icons/hicolor/256x256/apps/pixelorama.png
    install -d -m 755 $out/bin
    ln -s $out/libexec/pixelorama $out/bin/pixelorama

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "Free & open-source 2D sprite editor, made with the Godot Engine";
    changelog = "https://github.com/Orama-Interactive/Pixelorama/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ felschr ];
    mainProgram = "pixelorama";
  };
})
