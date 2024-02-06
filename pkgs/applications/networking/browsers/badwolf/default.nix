{ stdenv
, lib
, fetchgit
, pkg-config
, wrapGAppsHook
, webkitgtk
, libxml2
, glib
, glib-networking
, gettext
}:
stdenv.mkDerivation rec {
  pname = "badwolf";
  version = "1.2.2";

  src = fetchgit {
    url = "git://hacktivis.me/git/badwolf.git";
    rev = "v${version}";
    hash = "sha256-HfAsq6z+1kqMAsNxJjWJx9nd2cbv0XN4KRS8cYuhOsQ=";
  };

  preConfigure = ''
    export PREFIX=$out
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ webkitgtk libxml2 gettext glib glib-networking ];

  meta = with lib; {
    description = "Minimalist and privacy-oriented WebKitGTK+ browser";
    homepage = "https://hacktivis.me/projects/badwolf";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ laalsaas ];
  };

}
