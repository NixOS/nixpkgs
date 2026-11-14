{
  lib,
  stdenv,
  fetchFromGitHub,
  lv2,
}:

stdenv.mkDerivation {
  pname = "mod-distortion";
  version = "0-unstable-2016-08-19";

  src = fetchFromGitHub {
    owner = "mod-audio";
    repo = "mod-distortion";
    rev = "e672d5feb9d631798e3d56eb96e8958c3d2c6821";
    hash = "sha256-ZPBmCNkJ/uwVLvLAXZjP3qCH47ecpQA2lq8lC9dsvAA=";
  };

  buildInputs = [ lv2 ];

  installFlags = [ "INSTALL_PATH=$(out)/lib/lv2" ];

  meta = {
    homepage = "https://github.com/mod-audio/mod-distortion";
    description = "Analog distortion emulation lv2 plugins";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
