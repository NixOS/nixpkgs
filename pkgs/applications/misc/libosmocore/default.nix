{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pcsclite, talloc, python2, gnutls
}:

stdenv.mkDerivation rec {
  name = "libosmocore-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    sha256 = "08xbj2calh1zkp79kxbq01vnh0y7nkgd4cgsivrzlyqahilbzvd9";
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
