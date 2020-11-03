{ mkDerivation
, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qtmultimedia
, libvorbis
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.3.4.1";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "0rjyhxfad864w84n0bxyhc1jjxhzwwdx26r6psba2582g90cv024";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtmultimedia libvorbis ];

  meta = with stdenv.lib; {
    description = "Experimental pxtone editor where you can collaborate with friends";
    homepage = "https://yuxshao.github.io/ptcollab/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    # Requires Qt5.15
    broken = stdenv.hostPlatform.isDarwin;
  };
}
