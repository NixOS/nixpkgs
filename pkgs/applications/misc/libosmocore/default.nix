{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pcsclite, talloc, python2, gnutls
}:

stdenv.mkDerivation rec {
  name = "libosmocore-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    sha256 = "1ayxpq03mv547sirdy3j9vnsjd1q07adhwwnl3wffz3c39wlax68";
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
