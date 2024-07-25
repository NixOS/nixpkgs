{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, docutils
, gi-docgen
, gobject-introspection
, gtk-doc
, libxslt
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook3
, glib
, gsound
, json-glib
, libgudev
, dbus
, cmake
, gmobile
, umockdev
}:

let
  themes = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd-device-themes";
    rev = "v0.4.0";
    hash = "sha256-kY/+DyRxKEUzq7ctl6Va14AKUCpWU7NRQhJOwhtkJp8=";
  };
in
stdenv.mkDerivation rec {
  pname = "feedbackd";
  version = "0.4.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
    hash = "sha256-zjq1UT/r768KVRKm8fWsdPBahqKy2ofnK0LnTKCy4/g=";
    fetchSubmodules = true;
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    docutils # for rst2man
    gi-docgen
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    cmake
    umockdev
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
    gmobile
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dman=true"
  ];

  nativeCheckInputs = [
    dbus
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/debian/feedbackd.udev > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  meta = with lib; {
    description = "Daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
}
