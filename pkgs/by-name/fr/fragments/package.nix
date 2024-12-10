{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  cargo,
  dbus,
  desktop-file-utils,
  git,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  transmission_4,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "fragments";
  version = "3.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    hash = "sha256-HtulyB1XYBsA595ghJN0EmyJT7DjGUbtJKaMGM3f0I8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-EUE+Qc+MqsKPqHMYJflZQ6zm3ErW+KLuJq/7HEBf8VM=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    openssl
    sqlite
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ transmission_4 ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Fragments";
    description = "Easy to use BitTorrent client for the GNOME desktop environment";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "fragments";
  };
}
