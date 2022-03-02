{ lib
, stdenv
, fetchFromGitLab
, meson
, rustPlatform
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, appstream-glib
, python3
, glib
, gtk4
, libtransmission
, transmission
, curl
, openssl
, zlib
, sqlite
, dbus
, libadwaita
, git
}:

stdenv.mkDerivation rec {
  pname = "fragments";
  version = "2.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    sha256 = "sha256-CMa1yka0kOxMhxSuazlJxTk4fzxuuwKYLBpEMwHbBUE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-/rFZcbpITYkpSCEZp9XH253u90RGmuVLEBGIRNBgI/o=";
  };

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    ninja
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    python3
    git
  ];

  buildInputs = [
    glib
    gtk4
    libtransmission
    curl
    openssl
    zlib
    sqlite
    dbus
    libadwaita
  ];

  postInstall = ''
    wrapProgram $out/bin/fragments \
      --prefix PATH : ${lib.makeBinPath [transmission]}
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Fragments";
    description = "A BitTorrent Client";
    maintainers = with maintainers; [ emilytrau fgaz ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
