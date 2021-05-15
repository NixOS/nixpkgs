{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, pcsclite, talloc, python2, gnutls
}:

stdenv.mkDerivation rec {
  pname = "libosmocore";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    sha256 = "1535y6r4csvslrxcki80ya6zhhc5jw2nvy9bymb55ln77pf853vg";
  };

  propagatedBuildInputs = [
    talloc
  ];

  nativeBuildInputs = [
    autoreconfHook pkg-config
  ];

  buildInputs = [
    pcsclite python2 gnutls
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
