{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pulseaudio,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    tag = "epoch-${version}";
    hash = "sha256-ezOeRgqI/GOWFknUVZI7ZLEy1GYaBI+/An83HWKL6ho=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vYehF2RjPrTZiuGcRUe4XX3ftRo7f+SIoKizD/kOtR8=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nyabinary
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
  };
}
