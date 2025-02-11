{
  lib,
  stdenv,
  fetchFromGitHub,
  lv2,
}:

stdenv.mkDerivation {
  pname = "mod-distortion";
  version = "unstable-2016-08-19";

  src = fetchFromGitHub {
    owner = "portalmod";
    repo = "mod-distortion";
    rev = "e672d5feb9d631798e3d56eb96e8958c3d2c6821";
    sha256 = "005wdkbhn9dgjqv019cwnziqg86yryc5vh7j5qayrzh9v446dw34";
  };

  buildInputs = [ lv2 ];

  installFlags = [ "INSTALL_PATH=$(out)/lib/lv2" ];

  meta = with lib; {
    homepage = "https://github.com/portalmod/mod-distortion";
    description = "Analog distortion emulation lv2 plugins";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
