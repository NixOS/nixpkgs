{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, appstream-glib
, cargo
, dbus
, desktop-file-utils
, git
, glib
, gtk4
, libadwaita
, meson
, ninja
, openssl
, pkg-config
, rustPlatform
, rustc
, sqlite
, transmission
, wrapGAppsHook4
}:

let
  patchedTransmission = transmission.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/flathub/de.haeckerfelix.Fragments/2aee477c8e26a24570f8dbbdbd1c49e017ae32eb/transmission_pdeathsig.patch";
        sha256 = "sha256-/rCoA566tMmzqcIfffC082Y56TwEyyQJ0knxymtscbA=";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "fragments";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    sha256 = "sha256-tZcVw4rxmNPcKKgyRB+alEktktZfKK+7FYUVAAGA9bw=";
  };

  patches = [];
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-nqVaYnL3jKGBsAsakIkgwksjH4yuMhwCQe0zq3jgjnA=";
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

  preFixup =  ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ patchedTransmission ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Fragments";
    description = "Easy to use BitTorrent client for the GNOME desktop environment";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
