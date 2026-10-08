{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  glibcLocales,
}:

stdenv.mkDerivation {
  pname = "libfort";
  version = "0.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "seleznevae";
    repo = "libfort";
    tag = "v0.5.1";
    hash = "sha256-UHDApOTrPNb3e5qoWqsTcx16/rV0nO/Zn4DNH9bEJY0=";
  };

  nativeBuildInputs = [
    cmake
    glibcLocales
  ];
  # Fixed upstream in https://github.com/seleznevae/libfort/pull/76
  # Merged but not released yet
  patches = [ ./libfort-pc.patch ];
  doCheck = true;
  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    ctest --output-on-failure
  '';

  meta = with lib; {
    description = "C/C++ library to create formatted ASCII tables for console applications";
    homepage = "https://github.com/seleznevae/libfort";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
