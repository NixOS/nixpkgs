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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "0mgn7lkpgj72hsybnnj0kpfyls4aha1qvv4nhdyclqdfbb6mldxg";
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
