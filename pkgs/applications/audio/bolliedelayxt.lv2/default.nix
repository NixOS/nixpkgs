{ lib, stdenv, fetchFromGitHub, lv2 }:

stdenv.mkDerivation  rec {
  pname = "bolliedelayxt.lv2";
  version = "unstable-2017-11-02";

  src = fetchFromGitHub {
    owner = "MrBollie";
    repo = pname;
    rev = "49c488523c8fb71cb2222d41f9f66ee0cb6b6d82";
    sha256 = "sha256-7GM3YccN22JQdQ5ng9HFs9R6Ex/d+XP/khTQsgbGcAw=";
  };

  buildInputs = [ lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A flexible LV2 delay plugin";
    homepage = "https://github.com/MrBollie/bolliedelayxt.lv2";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
