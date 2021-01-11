{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libuv, lv2 }:

stdenv.mkDerivation rec {
  pname = "eteroj.lv2";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "OpenMusicKontrollers";
    repo   = pname;
    rev    = version;
    sha256 = "0lzdk7hlz3vqgshrfpj0izjad1fmsnzk2vxqrry70xgz8xglvnmn";
  };

  buildInputs = [ libuv lv2 ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "OSC injection/ejection from/to UDP/TCP/Serial for LV2";
    homepage = "https://open-music-kontrollers.ch/lv2/eteroj";
    license = licenses.artistic2;
    maintainers = with maintainers; [ magnetophon ];
  };
}
