{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, makeWrapper
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
, which
, lld
, util-linuxMinimal
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings";
  version = "unstable-2023-12-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "5a452d7ac18a7c58ca990780bcc96c0bd0d18d09";
    hash = "sha256-ubOV+M4JCPJ51eTsyLj/QLu+ydlqG5jx+fC1RUzJ5Vs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-comp-config-0.1.0" = "sha256-WcO47SPiMOVEYxNgUPfvXhu/WnaE1MGtiXNm3dQK0L4=";
      "cosmic-config-0.1.0" = "sha256-B0N0802anWMKDTMbIfr9RvxsbdHn8UFO/bqtpc7mw8s=";
      "cosmic-client-toolkit-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "cosmic-panel-config-0.1.0" = "sha256-SDqNLuj219FMqlO2devw/DD04RJfSBJLDLH/4ObRCl8=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-3Dc2fU8xBVUmAs0Q1zEdcdG7vlxpBO+UIlyM/kzGcC4=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ cmake just pkg-config which lld util-linuxMinimal makeWrapper ];
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
  };
}
