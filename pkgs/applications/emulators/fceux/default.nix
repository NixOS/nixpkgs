{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook, SDL2, lua5_1, minizip, x264 }:

stdenv.mkDerivation rec {
  pname = "fceux";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-Q6r/iBlmi0z40+U6OLZCahS0io4IBBGZMP1mJH7szRM=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ SDL2 lua5_1 minizip x264 ];

  meta = with lib; {
    description = "A Nintendo Entertainment System (NES) Emulator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder scubed2 ];
    homepage = "http://www.fceux.com/";
    platforms = platforms.linux;
  };
}
