{ stdenv, fetchFromGitHub, gnumake,
  libX11, libXinerama, libXrandr, libXpm, libXft, imlib2 }:
stdenv.mkDerivation {
  pname = "wmfs";

  version = "201902";

  src = fetchFromGitHub {
    owner = "xorg62";
    repo = "wmfs";
    sha256 = "1m7dsmmlhq2qipim659cp9aqlriz1cwrrgspl8baa5pncln0gd5c";
    rev = "b7b8ff812d28c79cb22a73db2739989996fdc6c2";
  };

  nativeBuildInputs = [
    gnumake
  ];

  buildInputs = [
    imlib2
    libX11
    libXinerama
    libXrandr
    libXpm
    libXft
  ];

  preConfigure = "substituteInPlace configure --replace '-lxft' '-lXft'";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "XDG_CONFIG_DIR=${placeholder "out"}/etc/xdg"
    "MANPREFIX=${placeholder "out"}/share/man"
  ];

  meta = with stdenv.lib; {
    description = "Window manager from scratch";
    license = licenses.bsd2;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.linux;
  };
}
