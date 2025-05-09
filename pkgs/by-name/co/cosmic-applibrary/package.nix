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
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-2rGw4Jmr2rL9X1URA5wVPIZocuroS8yaQs42sJqiTbw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+nkXcbAPcIkg+p4ct/E0bm5O0n1MGN43AaWPjw13t9s=";

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
