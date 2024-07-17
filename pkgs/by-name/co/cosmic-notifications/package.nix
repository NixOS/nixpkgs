{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  which,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,
  appstream-glib,
  desktop-file-utils,
  intltool,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-notifications";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "3b07cf550a54b757a5f136e4d8fde74d09afe3fd";
    hash = "sha256-+S8bPorarSJQwIQfTmo4qK+B1kKAlQvllUuZ2UBL0eY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-AEgvF7i/OWPdEMi8WUaAg99igBwE/AexhAXHxyeJMdc=";
      "cosmic-config-0.1.0" = "sha256-DmuUvFjhoqI5lneiWFFYF3WM3mACx5ZfZqeKpsyL7Ss=";
      "cosmic-text-0.10.0" = "sha256-kIBhh6CakQaWGfBWu5qaV8LAbJENX7GW+BStJK/P4iA=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "glyphon-0.3.0" = "sha256-JGkNIfj1HjOF8kGxqJPNq/JO+NhZD6XrZ4KmkXEP6Xc=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    which
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    wayland
    appstream-glib
    desktop-file-utils
    intltool
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  postInstall = ''
    wrapProgram $out/bin/cosmic-notifications \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    mainProgram = "cosmic-notifications";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
