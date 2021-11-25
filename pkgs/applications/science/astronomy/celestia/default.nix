{ lib, stdenv, fetchFromGitHub, pkg-config, freeglut, gtk2, gtkglext
, libjpeg_turbo, libtheora, libXmu, lua, libGLU, libGL, perl, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "celestia";
  version = "1.6.2.2";

  src = fetchFromGitHub {
    owner = "CelestiaProject";
    repo = "Celestia";
    rev = version;
    sha256 = "1s9fgxh6i3x1sy75y5wcidi2mjrf5xj71dd4n6rg0hkps441sgsp";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    freeglut gtk2 gtkglext lua perl
    libjpeg_turbo libtheora libXmu libGLU libGL
  ];

  configureFlags = [
    "--with-gtk"
    "--with-lua=${lua}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://celestia.space/";
    description = "Real-time 3D simulation of space";
    changelog = "https://github.com/CelestiaProject/Celestia/releases/tag/${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
