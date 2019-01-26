{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pcsclite, talloc, python2, gnutls
}:

stdenv.mkDerivation rec {
  name = "libosmocore-${version}";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    sha256 = "140c9jii0qs00s50kji1znc2339s22x8sz259x4pj35rrjzyyjgp";
  };

  propagatedBuildInputs = [
    talloc
  ];

  nativeBuildInputs = [
    autoreconfHook pkgconfig
  ];

  buildInputs = [
    pcsclite python2 gnutls
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "libosmocore";
    homepage = https://github.com/osmocom/libosmocore;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
