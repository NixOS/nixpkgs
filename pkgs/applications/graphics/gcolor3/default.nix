{ lib, stdenv
, fetchFromGitLab
, meson
, ninja
, gettext
, pkg-config
, libxml2
, gtk3
, libportal
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gcolor3";
  version = "2.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gcolor3";
    rev = "v${version}";
    sha256 = "rHIAjk2m3Lkz11obgNZaapa1Zr2GDH7XzgzuAJmq+MU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    libxml2 # xml-stripblanks preprocessing of GResource
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libportal
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with lib; {
    description = "A simple color chooser written in GTK3";
    homepage = "https://gitlab.gnome.org/World/gcolor3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
