{ stdenv
, fetchFromGitHub
, fetchpatch
, vala
, meson
, ninja
, pkgconfig
, python3
, libgee
, gsettings-desktop-schemas
, gnome3
, pantheon
, wrapGAppsHook
, gtk3
, json-glib
, glib
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "tootle";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    rev = version;
    sha256 = "1z3wyx316nns6gi7vlvcfmalhvxncmvcmmlgclbv6b6hwl5x2ysi";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gnome3.libsoup
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    pantheon.granite
  ];

  patches = [
    # Fix build with Vala 0.46
    # https://github.com/bleakgrey/tootle/pull/164
    (fetchpatch {
      url = "https://github.com/worldofpeace/tootle/commit/0a88bdad6d969ead1e4058b1a19675c9d6857b16.patch";
      sha256 = "0xyx00pgswnhxxbsxngsm6khvlbfcl6ic5wv5n64x7klk8rzh6cm";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Simple Mastodon client designed for elementary OS";
    homepage = https://github.com/bleakgrey/tootle;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
