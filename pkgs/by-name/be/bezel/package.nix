{
  lib,
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  gawk,
  libnotify,
  makeBinaryWrapper,
  pkg-config,
  python3Minimal,
  udev,
  nix-update-script,
  runtimeShell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bezel";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Indra55";
    repo = "bezel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DPIiyIMaDtBmMZeOMzsreQ95Lv66E10j+LFF0p7qAZE=";
  };

  cargoHash = "sha256-/vNJ+3tN1NgPsVM6e2nBDiDGU611CPK7Wd6cPBoP8+0=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];
  buildInputs = [ udev ];

  # The OSD backend name is also matched as "notify-send", so only patch the spawned program
  postPatch = ''
    substituteInPlace src/dispatcher.rs \
      --replace-fail '"sh"' '"${runtimeShell}"' \
      --replace-fail 'Command::new("notify-send")' 'Command::new("${lib.getExe' libnotify "notify-send"}")'
  '';

  postInstall = ''
    install -Dm755 onboard.sh $out/bin/bezel-onboard
    substituteInPlace $out/bin/bezel-onboard \
      --replace-fail '#!/usr/bin/env bash' '#!${runtimeShell}'
    wrapProgram $out/bin/bezel-onboard \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          python3Minimal
        ]
      }

    install -Dm644 config.toml.example -t $out/share/bezel
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Per-edge-zone trackpad gesture daemon";
    longDescription = ''
      Bezel is a daemon that provides customizable trackpad edge
      gestures.  It intercepts raw trackpad inputs via `evdev` and
      dispatches shell commands based on directional swipes or taps
      along the edges (zones) of your trackpad.
    '';
    changelog = "https://github.com/Indra55/bezel/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/Indra55/bezel";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bezel";
    maintainers = with lib.maintainers; [
      olimoli
      yiyu
    ];
    platforms = lib.platforms.linux;
  };
})
