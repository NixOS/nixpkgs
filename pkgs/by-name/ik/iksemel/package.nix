{
  lib,
  stdenv,
  autoreconfHook,
  libtool,
  pkg-config,
  gnutls,
  fetchFromGitHub,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "iksemel";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "timothytylee";
    repo = "iksemel-1.4";
    rev = "v${version}";
    sha256 = "1xv302p344hnpxqcgs3z6wwxhrik39ckgfw5cjyrw0dkf316z9yh";
  };

  patches = [
    ./update-texinfo.diff
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
    texinfo
  ];
  buildInputs = [ gnutls ];

<<<<<<< HEAD
  meta = {
    description = "XML parser for jabber";

    homepage = "https://github.com/timothytylee/iksemel-1.4";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ disassembler ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "XML parser for jabber";

    homepage = "https://github.com/timothytylee/iksemel-1.4";
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
