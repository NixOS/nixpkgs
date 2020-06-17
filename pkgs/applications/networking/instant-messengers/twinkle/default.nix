{ stdenv
, fetchFromGitHub
, cmake
, libxml2
, libsndfile
, file
, readline
, bison
, flex
, ucommon
, ccrtp
, qtbase
, qttools
, qtquickcontrols2
, alsaLib
, speex
, ilbc
, fetchurl
, mkDerivation
, bcg729
}:

mkDerivation rec {
  pname = "twinkle";
  version = "1.10.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "LubosD";
    rev = "v${version}";
    sha256 = "0s0gi03xwvzp02ah4q6j33r9jx9nbayr6dxlg2ck9pwbay1nq1hx";
  };

  buildInputs = [
    libxml2
    file # libmagic
    libsndfile
    readline
    ucommon
    ccrtp
    qtbase
    qttools
    qtquickcontrols2
    alsaLib
    speex
    ilbc
  ];

  patches = [
    # patch for bcg729 1.0.2+
    (fetchurl { # https://github.com/LubosD/twinkle/pull/152
      url = "https://github.com/LubosD/twinkle/compare/05082ae12051821b1d969e6672d9e4e5afe1bc07...7a6c533cda387652b5b4cb2a867be1a18585890c.patch";
      sha256 = "39fc6cef3e88cfca8db44612b2d082fb618027b0f99509138d3c0d2777a494c2";
    })
    # patch manual link to not link to old url, which now points to NSFW page
    (fetchurl { # https://github.com/LubosD/twinkle/commit/05082ae12051821b1d969e6672d9e4e5afe1bc07
      url = "https://github.com/LubosD/twinkle/commit/05082ae12051821b1d969e6672d9e4e5afe1bc07.diff";
      sha256 = "1iamragr9wp2vczsnp6n261fpr1ai2nc2abp0228jlar9zafksw0";
    })
  ];

  nativeBuildInputs = [
    cmake
    bison
    flex
    bcg729
  ];

  cmakeFlags = [
    "-DWITH_G729=On"
    "-DWITH_SPEEX=On"
    "-DWITH_ILBC=On"
    /* "-DWITH_DIAMONDCARD=On" seems ancient and broken */
  ];

  meta = with stdenv.lib; {
    changelog = "https://github.com/LubosD/twinkle/blob/${version}/NEWS";
    description = "A SIP-based VoIP client";
    homepage = "http://twinkle.dolezel.info/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
  };
}
