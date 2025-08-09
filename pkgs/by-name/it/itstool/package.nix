{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  python3,
  autoreconfHook,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.7";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-a5p80poSu5VZj1dQ6HY87niDahogf4W3TYsydbJ+h8o=";
  };

  patches = [
    # https://github.com/itstool/itstool/pull/51
    (fetchpatch {
      name = "fix-insufficiently-quoted-regular-expressions-pr51";
      url = "https://github.com/itstool/itstool/commit/19f9580f27aa261ea383b395fdef7e153f3f9e6d.patch";
      hash = "sha256-5J4mRXQu24o2rqVtaXN/ETgj6A8R0Ym+YkZhqhZTzIc=";
    })
  ];

  strictDeps = true;

  postPatch = ''
    # Do not let autoconf find Python, but set it directly. This fixes cross-compilation.
    substituteInPlace configure.ac \
      --replace-fail 'AM_PATH_PYTHON([2.6])' "" \
      --replace-fail 'AC_MSG_ERROR(Python module $py_module is needed to run this package)' ""
    substituteInPlace itstool.in \
      --replace-fail "@PYTHON@" "${python3.interpreter}"
  '';

  nativeBuildInputs = [
    autoreconfHook
    python3.pkgs.wrapPython
  ];

  pythonPath = [
    python3.pkgs.libxml2
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
