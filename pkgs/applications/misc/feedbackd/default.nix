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

stdenv.mkDerivation rec {
  pname = "feedbackd";
  # Not an actual upstream project release,
  # only a Debian package release that is tagged in the upstream repo
  version = "0.0.0+git20210426";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
    sha256 = "12kdchv11c5ynpv6fbagcx755x5p2kd7acpwjxi9khwdwjsqxlmn";
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
  '';

  meta = with lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
}
