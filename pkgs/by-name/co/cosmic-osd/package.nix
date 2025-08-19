{
  lib,
  fetchFromGitHub,
  sound-theme-freedesktop,
  rustPlatform,
  libcosmicAppHook,
  pulseaudio,
  udev,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.7";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-POjuxrNBajp4IOw7YwF2TS4OfoM8Hxo1fO48nkhKj8U=";
  };

  postPatch = ''
    substituteInPlace src/components/app.rs \
      --replace-fail '/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga' '${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga'
  '';

  cargoHash = "sha256-kfExKggQo3MoTXw1JbKWjLu5kwYF0n7DzSQcG6e1+QQ=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
