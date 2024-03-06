{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, makeBinaryWrapper
, cosmic-icons
, just
, pkg-config
, libxkbcommon
, libinput
, fontconfig
, freetype
, wayland
, expat
, udev
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings";
  version = "unstable-2024-01-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "f2148eed9a56ef1b5ba73db73e15486e188e01b7";
    hash = "sha256-JUiUC/RNR1cqJouUEneHZotkN2M18vJhv+ATvGFrQxU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-comp-config-0.1.0" = "sha256-xN5VbxRO50BPU0VP1rSOkq3TS2WTiCGavJS8o05Jw50=";
      "cosmic-config-0.1.0" = "sha256-/oAG5xu0Lnsw/CIGXrvoC3pKkj5aS0qubWIPozQDSsY=";
      "cosmic-client-toolkit-0.1.0" = "sha256-AEgvF7i/OWPdEMi8WUaAg99igBwE/AexhAXHxyeJMdc=";
      "cosmic-panel-config-0.1.0" = "sha256-SDqNLuj219FMqlO2devw/DD04RJfSBJLDLH/4ObRCl8=";
      "glyphon-0.3.0" = "sha256-Uw1zbHVAjB3pUfUd8GnFUnske3Gxs+RktrbaFJfK430=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-3Dc2fU8xBVUmAs0Q1zEdcdG7vlxpBO+UIlyM/kzGcC4=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ cmake just pkg-config makeBinaryWrapper ];
  buildInputs = [ libxkbcommon libinput fontconfig freetype wayland expat udev ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    wrapProgram "$out/bin/cosmic-settings" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
