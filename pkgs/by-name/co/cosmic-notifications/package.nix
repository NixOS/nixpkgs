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
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "epoch-${version}";
    hash = "sha256-tCizZePze94tbJbR91N9rfUhrLFTAMW2oL9ByKOeDAU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-36M7hDt8kd2Q94AR3IJhC2lKDLW2wRWWeqh3rEaRPTo=";

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
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
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
