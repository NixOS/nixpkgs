{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  glib,
  json-glib,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "jsonrpc-glib";
  version = "3.44.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "llSWtuExTzRotIKl2ANA3DsDQKVALXeDytJBVK7nc5Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    glib
    json-glib
  ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  # Tests fail non-deterministically
  # https://gitlab.gnome.org/GNOME/jsonrpc-glib/issues/2
  doCheck = false;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library to communicate using the JSON-RPC 2.0 specification";
    homepage = "https://gitlab.gnome.org/GNOME/jsonrpc-glib";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
