{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  alsa-lib,
  fontconfig,
  mesa_glu,
  libXcursor,
  libXinerama,
  libXrandr,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "bonzomatic";
  version = "2023-06-15";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "bonzomatic";
    rev = version;
    sha256 = "sha256-hwK3C+p1hRwnuY2/vBrA0QsJGIcJatqq+U5/hzVCXEg=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    fontconfig
    mesa_glu
    libXcursor
    libXinerama
    libXrandr
    xorg.xinput
    xorg.libXi
    xorg.libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic --prefix LD_LIBRARY_PATH : "${alsa-lib}/lib"
  '';

  meta = with lib; {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = licenses.unlicense;
    maintainers = [ maintainers.ilian ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "bonzomatic";
  };
}
