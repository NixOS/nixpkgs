{
  stdenv,
  lib,
  fetchurl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.7";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-a5p80poSu5VZj1dQ6HY87niDahogf4W3TYsydbJ+h8o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    python3
    python3.pkgs.libxml2
  ];

  pythonPath = [
    python3.pkgs.libxml2
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://itstool.org/";
    description = "XML to PO and back again";
    mainProgram = "itstool";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
