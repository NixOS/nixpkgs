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
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.0.0-beta.7";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b44x+VyoiDafsPqfCTPm70zZJfNYQ31/UXsrXP6K29E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-kgXt5enZ0VJr6hmEVcCREna4Y53q1jEFzUMsGtV2zvY=";
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
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
