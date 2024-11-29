{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, gobject-introspection
, gdk-pixbuf
, caja
, gtk3
, python3
, dropbox
, mateUpdateScript
}:

let
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation rec {
  pname = "caja-dropbox";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "t0w4qZQlS9PPfLxxK8LsdRagypQqpleFJs29aqYgGWM=";
  };

  patches = [
    (substituteAll {
      src = ./fix-cli-paths.patch;
      inherit dropboxd;
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gdk-pixbuf
    (python3.withPackages (ps: with ps; [
      docutils
      pygobject3
    ]))
  ];

  buildInputs = [
    caja
    gtk3
    python3
  ];

  configureFlags = [ "--with-caja-extension-dir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Dropbox extension for Caja file manager";
    homepage = "https://github.com/mate-desktop/caja-dropbox";
    license = with licenses; [ gpl3Plus cc-by-nd-30 ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
