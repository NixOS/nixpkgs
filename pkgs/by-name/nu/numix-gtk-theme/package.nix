{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  libxml2,
  nix-update-script,
  sassc,
}:

stdenvNoCC.mkDerivation {
  pname = "numix-gtk-theme";
  version = "0-unstable-2021-06-08";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-gtk-theme";
    rev = "ad4b345cb19edba96bec72d6dc97ed1b568755a8";
    hash = "sha256-7KX5xC6Gr6azqL2qyc8rYb3q9UhcGco2uEfltsQ+mgo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;

  nativeBuildInputs = [
    gdk-pixbuf
    glib
    libxml2
    sassc
  ];

  postPatch = ''
    patchShebangs scripts

    substituteInPlace Makefile \
      --replace-fail '$(DESTDIR)'/usr $out

    # The GTK2 theme needs gtk-engine-murrine, which is no longer packaged.
    substituteInPlace scripts/utils.sh \
      --replace-fail 'assets gtk-2.0 metacity-1' 'assets metacity-1'
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = "https://numixproject.github.io";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
