{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  just,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-applibrary";
  version = "0-unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "e214e9867876c96b24568d8a45aaca2936269d9b";
    hash = "sha256-fZxDRktiHHmj7X3e5VyJJMO081auOpSMSsBnJdhhtR8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WCS1jCfnanILXGLq96+FI0gM1o4FIJQtSgZg86fe86E=";

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  postInstall = ''
    wrapProgram $out/bin/cosmic-app-library \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
