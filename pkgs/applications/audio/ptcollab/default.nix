{ mkDerivation
, lib, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qtmultimedia
, libvorbis
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.3.5.1";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "1ahfxjm1chz8k65rs7rgn4s2bgippq58fjcxl8fr21pzn718wqf1";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtmultimedia libvorbis ];

  meta = with lib; {
    description = "Experimental pxtone editor where you can collaborate with friends";
    homepage = "https://yuxshao.github.io/ptcollab/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    # Requires Qt5.15
    broken = stdenv.hostPlatform.isDarwin;
  };
}
