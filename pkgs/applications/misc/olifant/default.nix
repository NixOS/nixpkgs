{ stdenv
, fetchFromGitHub
, nix-update-script
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
  pname = "olifant";
  version = "0.2.1-beta5";

  src = fetchFromGitHub {
    owner = "cleac";
    repo = pname;
    rev = version;
    sha256 = "1fpyg3nii75vmsdhp8x4yvhi3npvp3xnbqmd0qcidn05mbsam68r";
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

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple Mastodon client designed for elementary OS, originally developed by @bleakgrey";
    homepage = "https://github.com/cleac/olifant";
    license = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
