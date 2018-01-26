{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pcsclite, talloc, python2
}:

stdenv.mkDerivation rec {
  name = "libosmocore-${version}";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = "3cc757df1822114bf446dc2d5f6a95da92321a25";
    sha256 = "0dk7065qcy2kjra0p8q2124p73jcyvvzz3cmhid1kx5scyxmr017";
  };

  propagatedBuildInputs = [
    talloc
  ];

  nativeBuildInputs = [
    autoreconfHook pkgconfig
  ];

  buildInputs = [
    pcsclite python2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "libosmocore";
    homepage = https://github.com/osmocom/libosmocore;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
