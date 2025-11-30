{
  lib,
  stdenv,
  fetchFromGitHub,
  libtool,
  autoconf,
  automake,
}:

stdenv.mkDerivation rec {
  pname = "libmkv";
  version = "0.6.5.1";

  src = fetchFromGitHub {
    owner = "saintdev";
    repo = "libmkv";
    tag = version;
    sha256 = "0pr9q7yprndl8d15ir7i7cznvmf1yqpvnsyivv763n6wryssq6dl";
  };

  nativeBuildInputs = [
    libtool
    autoconf
    automake
  ];

  preConfigure = "sh bootstrap.sh";

  meta = {
    description = "Abandoned library. Alternative lightweight Matroska muxer written for HandBrake";
    longDescription = ''
      Library was meant to be an alternative to the official libmatroska library.
      It is written in plain C, and intended to be very portable.
    '';
    homepage = "https://github.com/saintdev/libmkv";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
  };
}
