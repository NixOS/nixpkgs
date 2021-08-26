{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, nix-update-script
, qmake
, pkg-config
, qtbase
, qtmultimedia
, libvorbis
, rtmidi
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "sha256-AeIjc+FoFsTcyWl261GvyySIHP107rL4JkuMXFhnPbk=";
  };

  nativeBuildInputs = [ qmake pkg-config ];

  buildInputs = [ qtbase qtmultimedia libvorbis rtmidi ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

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
