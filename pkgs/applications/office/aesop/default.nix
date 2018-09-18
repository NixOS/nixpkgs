{ stdenv, fetchFromGitHub, vala, pkgconfig, meson, ninja, python3, granite, gtk3, gnome3
, desktop-file-utils, json-glib, libsoup, poppler, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "aesop";
  version = "1.0.5";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "17hjg4qcy8q9xl170yapbhn9vdsn3jf537jsggq51pp0fnhvsnqs";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.libgee
    granite
    gtk3
    json-glib
    libsoup
    poppler
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The simplest PDF viewer around";
    homepage    = https://github.com/lainsce/aesop;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
