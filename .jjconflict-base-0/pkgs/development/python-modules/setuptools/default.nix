{
  stdenv,
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "78.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${version}";
    hash = "sha256-6vJ7nzpbm34cpso21Pnh9Ej9AhJa+4/K22XrwuF0R3k=";
  };

  patches = [
    ./tag-date.patch
  ];

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  passthru.tests = {
    inherit distutils;
  };

  meta = with lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://github.com/pypa/setuptools";
    changelog = "https://setuptools.pypa.io/en/stable/history.html#v${
      replaceStrings [ "." ] [ "-" ] version
    }";
    license = with licenses; [ mit ];
    platforms = python.meta.platforms;
    teams = [ teams.python ];
  };
}
