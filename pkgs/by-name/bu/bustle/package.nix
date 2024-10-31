{ lib
, stdenv
, fetchFromGitLab
, buildPackages
, cargo
, meson
, ninja
, pkg-config
, desktop-file-utils
, rustPlatform
, rustc
, wrapGAppsHook4
, darwin
, gettext
, glib
, gtk4
, libadwaita
, libiconv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bustle";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "bustle";
    rev = finalAttrs.version;
    hash = "sha256-/B1rY8epcP0OFv+kVgv4Jx6x/oK3XpNnZcpSGvdIPx0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "bustle-${finalAttrs.version}";
    hash = "sha256-r29Z+6P+yuCpOBUE3vkESd15lcGXs5+ZTBiQ9nW6DJ4=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Set the location to gettext to ensure the nixpkgs one on Darwin instead of the vendored one.
    # The vendored gettext does not build with clang 16.
    GETTEXT_BIN_DIR = "${lib.getBin buildPackages.gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    desktop-file-utils
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
    libiconv
  ];

  meta = with lib; {
    description = "Graphical D-Bus message analyser and profiler";
    homepage = "https://gitlab.gnome.org/World/bustle";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    mainProgram = "bustle";
    platforms = platforms.all;
  };
})
