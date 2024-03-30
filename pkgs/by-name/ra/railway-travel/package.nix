{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  darwin,
}:
stdenv.mkDerivation rec {
  pname = "railway-travel";
  version = "2.4.0";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "railway";
    rev = version;
    hash = "sha256-2iLxErEP0OG+BcG7fvJBzNjh95EkNoC3NC7rKxPLhYk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-yalFC7Pw9rq1ylLwoxLi4joTyjQsZJ/ZC61GhTNc49w=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs =
    [
      cairo
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      pango
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Security
    ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Wno-error=incompatible-function-pointer-types" ]
  );

  meta = with lib; {
    description = "Find all your travel information";
    homepage = "https://gitlab.com/schmiddi-on-mobile/railway";
    changelog = "https://gitlab.com/schmiddi-on-mobile/railway/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lilacious ];
    mainProgram = "diebahn";
    platforms = platforms.all;
  };
}
