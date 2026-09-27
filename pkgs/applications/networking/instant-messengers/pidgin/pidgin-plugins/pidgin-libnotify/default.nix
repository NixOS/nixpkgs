{
  lib,
  stdenv,
  fetchurl,
  libotr,
  pidgin,
  intltool,
  fetchFromGitHub,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-libnotify";
  version = "0.14.1";
  src = fetchFromGitHub {
    owner = "qhga";
    repo = "pidgin-libnotify";
    rev = version;
    sha256 = "sha256-orKYYCa+382Ha5IuYOfBUVPUJZk1l4eQCEFDdR/WPTM=";
  };

  nativeBuildInputs = [
    intltool
  ];

  buildInputs = [
    pidgin
    libnotify
  ];

  makeFlags = [
    "gddir=${placeholder "out"}/lib/purple-2"
  ];

  meta = {
    homepage = "https://github.com/qhga/pidgin-libnotify";
    description = "Plugin for Pidgin 2.x which implements libnotify notification support";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
