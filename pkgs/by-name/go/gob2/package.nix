{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  bison,
  flex,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gob2";
  version = "2.0.20";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "5fe5d7990fd65b0d4b617ba894408ebaa6df453f2781c15a1cfdf2956c0c5428";
  };

  # configure script looks for d-bus but it is only needed for tests
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    bison
    flex
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Preprocessor for making GObjects with inline C code";
    mainProgram = "gob2";
    homepage = "https://www.jirka.org/gob.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
