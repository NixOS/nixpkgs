{ lib
, stdenv
, fetchFromGitHub
, cargo
, glib
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gdk-pixbuf
, gtk4
, libadwaita
, libsecret
, openssl
, sqlite
, darwin
, gettext
}:

stdenv.mkDerivation rec {
  pname = "done";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "done-devs";
    repo = "done";
    rev = "v${version}";
    hash = "sha256-SbeP7PnJd7jjdXa9uDIAlMAJLOrYHqNP5p9gQclb6RU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-YJJGQR1tkK5z7vQQgkd8xPSqYhtiZIN+s9Xnwjn0z5A=";
  };

  nativeBuildInputs = [
    cargo
    glib
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libadwaita
    libsecret
    openssl
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    GETTEXT_DIR = gettext;
  };

  meta = with lib; {
    description = "Ultimate task management solution for seamless organization and efficiency";
    homepage = "https://done.edfloreshz.dev/";
    changelog = "https://github.com/done-devs/done/blob/${src.rev}/CHANGES.md";
    license = licenses.mpl20;
    mainProgram = "done";
    maintainers = with maintainers; [ figsoda ];
  };
}
