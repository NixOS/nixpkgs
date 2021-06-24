{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, nix-update-script
, qmake
, qtbase
, qtmultimedia
, libvorbis
, rtmidi
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "1yfnf47saxxj17x0vyxihr343kp7gz3fashzky79j80sqlm6ng85";
  };

  postPatch = ''
    substituteInPlace src/editor.pro \
      --replace '/usr/include/rtmidi' '${rtmidi}/include/rtmidi'
  '';

  nativeBuildInputs = [ qmake ];

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
