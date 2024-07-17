{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-osd";
  version = "unstable-2023-11-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "c1d10382dd1132923a4ddc9c86bb89bd9a70cd68";
    hash = "sha256-KCjWTN6hjbmJU6UfCP5NWbLy2K09+eRY5U4cQ5iV3E4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "cosmic-config-0.1.0" = "sha256-7pfKQvScoahp+Fhv+QfgyIroCyQO6kjXcnTilBL41K8=";
      "smithay-client-toolkit-0.17.0" = "sha256-vDY4cqz5CZD12twElUWVCsf4N6VO9O+Udl8Dc4arWK4=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    wayland
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
