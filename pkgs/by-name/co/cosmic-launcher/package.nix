{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,
  appstream-glib,
  desktop-file-utils,
  intltool,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-launcher";
  version = "unstable-2023-12-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "d5098e3674d1044645db256347f232fb33334376";
    sha256 = "sha256-2nbjw6zynlmzoMBZhnQSnnQIgxkyq8JA+VSiQJHU6JQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-dvBYNtzKnbMTixe9hMNnEyiIsWd0KBCeVVbc19DPLMQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-AEgvF7i/OWPdEMi8WUaAg99igBwE/AexhAXHxyeJMdc=";
      "glyphon-0.3.0" = "sha256-Uw1zbHVAjB3pUfUd8GnFUnske3Gxs+RktrbaFJfK430=";
      "pop-launcher-1.2.2" = "sha256-yELJN6wnJxnHiF3r45nwN2UCpMQrpBJfUg2yGFa7jBY=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
    };
  };

  nativeBuildInputs = [
    just
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-launcher"
  ];

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  postInstall = ''
    wrapProgram $out/bin/cosmic-launcher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  RUSTFLAGS = "--cfg tokio_unstable";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-launcher";
    description = "Launcher for the COSMIC Desktop Environment";
    mainProgram = "cosmic-launcher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
