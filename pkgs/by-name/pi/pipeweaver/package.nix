{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  pipewire,
  nix-update-script,
}:
let
  pname = "pipeweaver";
  version = "0-unstable-2026-01-18";

  src = fetchFromGitHub {
    owner = "pipeweaver";
    repo = "pipeweaver";
    rev = "fae4e1190f339c80ec881fee16d2c200cec25643";
    hash = "sha256-YppeAyayvQCfyYbKULlJW5KlSiWvWkokQhuprTxqqho=";
  };

  web = buildNpmPackage {
    inherit version src;
    pname = "pipeweaver-web";

    npmDepsHash = "sha256-lq/ZVHYNpBUbKZnUbrC+QmpXt1SlLRkyGqhBX+ubeoA=";

    sourceRoot = "${src.name}/web";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;

  cargoHash = "sha256-QDzMis5NlKc0DvXET56clHQOvlAXrEC69FgG4poQwA0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
  ];

  # Prevent build.rs from running to prevent impure git and npm calls.
  postPatch = ''
    rm daemon/build.rs
    substituteInPlace daemon/Cargo.toml --replace-fail 'build = "build.rs"' ""
  '';
  # Provide GIT_HASH that build.rs would have set
  env = {
    GIT_HASH = src.rev;
  };

  preBuild = ''
    mkdir -p daemon/web-content
    cp -r ${web}/* daemon/web-content/
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp ${src}/daemon/resources/desktop/pipeweaver.desktop $out/share/applications/
    substituteInPlace $out/share/applications/pipeweaver.desktop \
      --replace-fail '/usr/bin/pipeweaver-daemon' "$out/bin/pipeweaver-daemon"

    mkdir -p $out/share/icons/hicolor/48x48/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps
    cp ${src}/daemon/resources/icons/pipeweaver.png $out/share/icons/hicolor/48x48/apps/
    cp ${src}/daemon/resources/icons/pipeweaver-large.png $out/share/icons/hicolor/128x128/apps/pipeweaver.png
  '';

  passthru = {
    inherit web;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "web"

        "--version=branch"
      ];
    };
  };

  meta = {
    description = "Manage streaming audio on Linux through PipeWire with virtual channels, mixing, and routing";
    homepage = "https://github.com/pipeweaver/pipeweaver";
    license = lib.licenses.mit;
    mainProgram = "pipeweaver-daemon";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bridgesense ];
  };
})
