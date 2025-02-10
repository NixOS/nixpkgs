{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  glib,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  libadwaita,
  libxml2,
  darwin,
  nix-update-script,
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-j9PrnXt0GyyfCKmcq1zYmDNlrvogtK5n316MIC+z+w0=";
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

  buildInputs =
    [
      libadwaita
      libxml2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
    ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=incompatible-function-pointer-types"
    ]
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate project icons and avatars from a symbolic icon";
    mainProgram = "emblem";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers =
      with lib.maintainers;
      [
        figsoda
        foo-dogsquared
      ]
      ++ lib.teams.gnome-circle.members;
  };
}
