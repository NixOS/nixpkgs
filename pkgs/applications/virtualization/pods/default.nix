{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.0.0-rc.2";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fyhp0Qumku2EO+5+AaWBLp6xG9mpfNuxhr/PoLca1a4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-v6ZGDd1mAxb55JIijJHlthrTta2PwZMRa8MqVnJMyzQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
