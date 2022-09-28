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
, wrapGAppsHook
, gtksourceview5
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.0.0-beta.4";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j5rz43860n17qcxmc5dj8sll3y593jj9zz1sfvnx4g0694sp0cl";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-tj0ROO8HmFWyQLYDrdywOneHz6X43dRZJFTB+aw+m7o=";
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
    wrapGAppsHook
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
