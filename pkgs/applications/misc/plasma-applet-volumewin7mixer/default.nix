{ stdenv, cmake, extra-cmake-modules, plasma-framework, kwindowsystem, plasma-pa, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "plasma-applet-volumewin7mixer";
  version = "24";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "plasma-applet-volumewin7mixer";
    rev = "v${version}";
    sha256 = "1pms71229y7fv3zs38a0l9mdcg5qkcdv9yrcvdm6xqpdyk21jbz2";
  };

  patches = [ ./cmake.patch ];
  postPatch = '' rm build '';
  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ plasma-framework kwindowsystem plasma-pa ];

  meta = with stdenv.lib; {
    description = "A fork of the default volume plasmoid with a Windows 7 theme (vertical sliders).";
    homepage = "https://github.com/Zren/plasma-applet-volumewin7mixer";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}
