{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  glib,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libadwaita,
  libsecret,
  openssl,
  sqlite,
  gettext,
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-yEpaQa9hKOq0k9MurihbFM4tDB//TPCJdOgKA9tyqVc=";
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
