{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, gobject-introspection
, gtk-doc
, libxslt
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
, glib
, gsound
, json-glib
, libgudev
, dbus
}:

let
  themes = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd-device-themes";
    rev = "v0.0.20210909";
    sha256 = "1d041wnq39sa0sl08xya4yp3n7j6aw560i38chl10vgpmwk9mmhr";
  };
in
stdenv.mkDerivation rec {
  pname = "feedbackd";
  # Not an actual upstream project release,
  # only a Debian package release that is tagged in the upstream repo
  version = "0.0.0+git20211018";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
    hash = "sha256-jqKRHcxISK54xq/tQm6zV+J+U71eKh04OVTNHDDy65E=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
  ];

  mesonFlags = [ "-Dgtk_doc=true" "-Dman=true" ];

  checkInputs = [
    dbus
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/debian/feedbackd.udev > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  meta = with lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
