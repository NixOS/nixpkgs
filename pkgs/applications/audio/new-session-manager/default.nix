{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja, liblo, libjack2, fltk }:

stdenv.mkDerivation rec {
  pname = "new-session-manager";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "linuxaudio";
    repo = "new-session-manager";
    rev = "v${version}";
    sha256 = "sha256-QVykRYXToeVXr7pYQy2afgEAlXrQnm68+xEUZhd+FkY=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  buildInputs = [ liblo libjack2 fltk ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://new-session-manager.jackaudio.org/";
    description = "A session manager designed for audio applications.";
    maintainers = [ maintainers._6AA4FD ];
    license = licenses.gpl3Plus;
    platforms = ["x86_64-linux"];
  };
}
