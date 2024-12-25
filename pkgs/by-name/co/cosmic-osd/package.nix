{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  pulseaudio,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "epoch-${version}";
    hash = "sha256-JDdVFNTJI9O88lLKB1esJE4sk7ZZnTMilQRZSAgnTqs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Db1a1FusUdO7rQb0jfznaFNaJjdS9XSDGCMuzV1D79A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    pulseaudio
    wayland
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
