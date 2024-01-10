{ lib
, stdenv
, fetchFromGitHub
, rust
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
  version = "unstable-2023-10-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "d15ebbd340dee7adf184831311b5da73faaa80f5";
    hash = "sha256-OlQ2jjT/ygO+hpl5Cc3h8Yp/SVo+pmI/EH7pqvY9GXI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-/6KUCH1CwMHd5YEMOpAdVeAxpjl9JvrzDA4Xnbd1D9k=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-comp-config-0.1.0" = "sha256-q0LP8TODETobYg0S6XDsP0Lw/RJIB8YB4jiUkRHpsio=";
      "cosmic-config-0.1.0" = "sha256-+mnvf/IM9cqoZv5zHW8uBAqeY2pG3IOiOWIESVExnqg=";
      "cosmic-panel-config-0.1.0" = "sha256-U5FYZ5hjJ5s6lYfWrgyuy8zLjiXGQV+OKwf6nzHZT6w=";
      "smithay-client-toolkit-0.17.0" = "sha256-vDY4cqz5CZD12twElUWVCsf4N6VO9O+Udl8Dc4arWK4=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-gPHJhYmDb3Pj7eM8eFv1kPoODk0BGiw+yMj9ROXIjAU=";
      "winit-0.28.6" = "sha256-8IQ6HyvD09v8+KWO5jbAkouRTTX/Des4Pn/sjGrtdok=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-pvaI/joul7jWTdIrPq3PbBcQGMLZLd2rTu1aIwXiZN8=";
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
