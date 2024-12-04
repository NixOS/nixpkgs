{ lib, stdenv, fetchFromGitHub, pkg-config, libglut, gtk2, gtkglext
, libjpeg_turbo, libtheora, libXmu, lua, libGLU, libGL, perl, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "celestia";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "CelestiaProject";
    repo = "Celestia";
    rev = version;
    sha256 = "sha256-MkElGo1ZR0ImW/526QlDE1ePd+VOQxwkX7l+0WyZ6Vs=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    libglut gtk2 gtkglext lua perl
    libjpeg_turbo libtheora libXmu libGLU libGL
  ];

  configureFlags = [
    "--with-gtk"
    "--with-lua=${lua}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://celestiaproject.space/";
    description = "Real-time 3D simulation of space";
    mainProgram = "celestia";
    changelog = "https://github.com/CelestiaProject/Celestia/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
