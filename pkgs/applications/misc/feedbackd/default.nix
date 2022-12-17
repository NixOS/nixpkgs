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
    rev = "v0.0.20220523";
    sha256 = "sha256-RyUZj+tpJSYhyoK+E98CTIoHwXwBdB1YHVnO5821exo=";
  };
in
stdenv.mkDerivation rec {
  pname = "feedbackd";
  version = "0.0.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
    hash = "sha256-ehWLC9PDDcD+muUPruzp8UvNddJBdrmW6gFxKVouY3c=";
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
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dman=true"
  ];

  checkInputs = [
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
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
