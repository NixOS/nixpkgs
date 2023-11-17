{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, wayland-scanner
, wayland
, gtk4
, gobject-introspection
, vala
}:

stdenv.mkDerivation rec {
  pname = "gtk4-layer-shell";
  version = "1.0.2";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # for demo

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk4-layer-shell";
    rev = "v${version}";
    sha256 = "sha256-decjPkFkYy7kIjyozsB7BEmw33wzq1EQyIBrxO36984=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    vala
    wayland-scanner
  ];

  buildInputs = [
    wayland
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dexamples=true"
  ];

  meta = with lib; {
    description = "Unsafe bindings and a safe wrapper for gtk4-layer-shell, automatically generated from a .gir file ";
    license = licenses.mit;
    maintainers = with maintainers; [ _8aed ];
    platforms = platforms.linux;
  };
}
