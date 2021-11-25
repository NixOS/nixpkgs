{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, vala_0_52
, meson
, ninja
, pkg-config
, python3
, libgee
, gsettings-desktop-schemas
, gnome
, pantheon
, wrapGAppsHook
, gtk3
, json-glib
, glib
, glib-networking
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "tootle";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    rev = version;
    sha256 = "NRM7GiJA8c5z9AvXpGXtMl4ZaYN2GauEIbjBmoY4pdo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    # Does not build with vala 0.54
    # https://github.com/bleakgrey/tootle/issues/337
    vala_0_52
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gnome.libsoup
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    pantheon.granite
    libhandy
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Simple Mastodon client designed for elementary OS";
    homepage = "https://github.com/bleakgrey/tootle";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
