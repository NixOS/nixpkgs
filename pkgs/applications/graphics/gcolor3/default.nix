{ lib, stdenv
, fetchFromGitLab
, meson
, ninja
, gettext
, pkg-config
, libxml2
, gtk3
, libportal-gtk3
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
    libportal-gtk3
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh

    # https://gitlab.gnome.org/World/gcolor3/merge_requests/151
    substituteInPlace meson.build --replace "dependency(${"\n"}  'libportal'" "dependency(${"\n"}  'libportal-gtk3'"
    substituteInPlace src/gcolor3-color-selection.c --replace "libportal/portal-gtk3.h" "libportal-gtk3/portal-gtk3.h"
  '';

  meta = with lib; {
    description = "A simple color chooser written in GTK3";
    homepage = "https://gitlab.gnome.org/World/gcolor3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
