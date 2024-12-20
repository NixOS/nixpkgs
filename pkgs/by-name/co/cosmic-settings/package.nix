{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeBinaryWrapper,
  cosmic-icons,
  cosmic-randr,
  just,
  pkg-config,
  libxkbcommon,
  libinput,
  fontconfig,
  freetype,
  wayland,
  expat,
  udev,
  util-linux,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "epoch-${version}";
    hash = "sha256-gTzZvhj7oBuL23dtedqfxUCT413eMoDc0rlNeqCeZ6E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zMHJc6ytbOoi9E47Zsg6zhbQKObsaOtVHuPnLAu36I4=";

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    cmake
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    libinput
    fontconfig
    freetype
    wayland
    expat
    udev
    util-linux
  ];

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
      --prefix PATH : ${lib.makeBinPath [ cosmic-randr ]} \
      --suffix XDG_DATA_DIRS : "$out/share:${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
