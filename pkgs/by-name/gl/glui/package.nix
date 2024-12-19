{
  lib,
  stdenv,
  fetchFromGitHub,
  libglut,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXi,
  libXmu,
}:

stdenv.mkDerivation rec {
  pname = "glui";
  version = "2.37";

  src = fetchFromGitHub {
    owner = "libglui";
    repo = "glui";
    rev = version;
    sha256 = "0qg2y8w95s03zay1qsqs8pqxxlg6l9kwm7rrs1qmx0h22sxb360i";
  };

  buildInputs = [
    libglut
    libGLU
    libGL
    libXmu
    libXext
    libX11
    libXi
  ];

  installPhase = ''
    mkdir -p "$out"/{bin,lib,share/glui/doc,include}
    cp -rT bin "$out/bin"
    cp -rT lib "$out/lib"
    cp -rT include "$out/include"
    cp -rT doc "$out/share/glui/doc"
    cp LICENSE.txt "$out/share/glui/doc"
  '';

  meta = with lib; {
    description = "User interface library using OpenGL";
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
