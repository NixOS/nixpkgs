#{ stdenv, lib, meson }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  pname = "gnote";
  version = "42.0";

  src = pkgs.fetchurl {
    url = "https://gitlab.gnome.org/GNOME/gnote/-/archive/${version}/gnote-${version}.tar.gz";
    sha256 = "1W1zGNwoM3ea2SCQwC7kpRSUS6n0sAY23Fiffny32k8=";
  };

  buildInputs = [
    glib
    gtkmm3
    gtk3
    gspell
    libxml2
    libxslt
    libuuid
    libsecret
    desktop-file-utils
  ];

  nativeBuildInputs = [
      pkg-config
      meson
      ninja
      gettext
      wrapGAppsHook
      docbook_xsl
      python3
      itstool
      yelp-tools
    ];

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gnote";
    description = "A note taking application";
    maintainers = [ maintainers.notthemessiah ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
