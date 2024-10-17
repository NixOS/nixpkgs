{
  stdenv,
  lib,
  fetchurl,
  python3Packages,
  versionCheckHook,
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
    python3Packages.python
    python3Packages.libxml2
    python3Packages.wrapPython
  ];

  pythonPath = [
    python3Packages.libxml2
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://itstool.org/";
    description = "XML to PO and back again";
    mainProgram = "itstool";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
