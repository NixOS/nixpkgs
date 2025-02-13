{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  pulseaudio,
  udev,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "epoch-${version}";
    hash = "sha256-a5wzCHfp+dhtEkXsJOeEs2ZkmooSWIDGymeAdrXKE+U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hJC0t8R+cdPWzdpxHA+j7en4IrhZXt5LM3S2V6/bps0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    pulseaudio
    wayland
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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
