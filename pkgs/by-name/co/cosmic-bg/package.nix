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
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-bg";
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "6a6fe4e387e46c2e159df56a9768220a6269ccf4";
    hash = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-config-0.1.0" = "sha256-vM5iIr71zg8OWShuoyQI+pV9C5dPXnvkfEVYAg0XAH4=";
      "smithay-client-toolkit-0.17.0" = "sha256-XXfXRXeEm2LCLTfyd74PYuLmTtLu50pcXKld/6H4juA=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  postInstall = ''
    wrapProgram $out/bin/cosmic-bg \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
