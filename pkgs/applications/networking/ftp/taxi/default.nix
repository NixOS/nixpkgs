{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, python3
, gtk3, gnome3, libsoup, libsecret, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "taxi";
  version = "0.0.1";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = "v${version}";
    sha256 = "01c552w68576pnsyqbwy3hjhbww6vys3r3s0wxjdiscjqj1aawqg";
  };

  nativeBuildInputs = [
    pantheon.vala
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.granite
    gnome3.libgee
    gtk3
    libsecret
    libsoup
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The FTP Client that drives you anywhere";
    homepage    = https://github.com/Alecaddd/taxi;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
