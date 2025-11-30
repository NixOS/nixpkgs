{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fontconfig,
  freetype,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "libemf2svg";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "kakwa";
    repo = "libemf2svg";
    rev = version;
    sha256 = "04g6dp5xadszqjyjl162x26mfhhwinia65hbkl3mv70bs4an9898";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fontconfig
    freetype
    libpng
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "Microsoft EMF to SVG conversion library";
    mainProgram = "emf2svg-conv";
    homepage = "https://github.com/kakwa/libemf2svg";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
