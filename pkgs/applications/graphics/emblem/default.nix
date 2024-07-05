{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, cargo
, desktop-file-utils
, glib
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4
, libadwaita
, libxml2
, darwin
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "emblem";
    rev = version;
    sha256 = "sha256-pW+2kQANZ9M1f0jMoBqCxMjLCu0xAnuEE2EdzDq4ZCE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2mxDXDGQA2YB+gnGwy6VSZP/RRBKg0RiR1GlXIkio9E=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    libadwaita
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Wno-error=incompatible-function-pointer-types"
  ]);

  meta = {
    description = "Generate project icons and avatars from a symbolic icon";
    mainProgram = "emblem";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ figsoda foo-dogsquared aleksana ];
  };
}
