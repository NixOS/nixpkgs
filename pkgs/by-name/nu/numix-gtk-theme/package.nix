{
  lib,
  stdenv,
  fetchFromGitHub,
  sassc,
  glib,
  libxml2,
  gdk-pixbuf,
  gtk-engine-murrine,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "numix-gtk-theme";
  version = "unstable-2021-06-08";

  src = fetchFromGitHub {
    repo = "numix-gtk-theme";
    owner = "numixproject";
    rev = "ad4b345cb19edba96bec72d6dc97ed1b568755a8";
    hash = "sha256-7KX5xC6Gr6azqL2qyc8rYb3q9UhcGco2uEfltsQ+mgo=";
  };

  nativeBuildInputs = [
    sassc
    glib
    libxml2
    gdk-pixbuf
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
    patchShebangs .
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
