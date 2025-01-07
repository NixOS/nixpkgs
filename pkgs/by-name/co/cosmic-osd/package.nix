{
  fetchFromGitHub,
  lib,
  libcosmicAppHook,
  pkg-config,
  pulseaudio,
  rustPlatform,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-wgQrHUphp6IJYEh5JKFarhkELetRvHSxTNHbyX5JqNM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VFsRYGgQW+j3efwiORz8owFs09qdhXUatBi1bnaNcJg=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-osd";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
