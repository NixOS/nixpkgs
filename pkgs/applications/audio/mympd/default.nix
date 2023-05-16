{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libmpdclient
, openssl
, lua5_3
, libid3tag
, flac
, pcre2
, gzip
, perl
, jq
}:

stdenv.mkDerivation rec {
  pname = "mympd";
<<<<<<< HEAD
  version = "11.0.5";
=======
  version = "10.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jcorporation";
    repo = "myMPD";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-m+EO3+vVqX7/SNvbQrJVjhG53Q20f6cEJ2HNUdWeeiw=";
=======
    sha256 = "sha256-KQf+Szr/AunL/roCtRPiC771P2A3POXPFlXUhbNej6g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    gzip
    perl
    jq
  ];
  preConfigure = ''
    env MYMPD_BUILDDIR=$PWD/build ./build.sh createassets
  '';
  buildInputs = [
    libmpdclient
    openssl
    lua5_3
    libid3tag
    flac
    pcre2
  ];

  cmakeFlags = [
<<<<<<< HEAD
=======
    "-DENABLE_LUA=ON"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Otherwise, it tries to parse $out/etc/mympd.conf on startup.
    "-DCMAKE_INSTALL_SYSCONFDIR=/etc"
    # similarly here
    "-DCMAKE_INSTALL_LOCALSTATEDIR=/var/lib/mympd"
  ];
<<<<<<< HEAD
  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];
  # 5 tests out of 23 fail, probably due to the sandbox...
  doCheck = false;
=======
  # See https://github.com/jcorporation/myMPD/issues/315
  hardeningDisable = [ "strictoverflow" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://jcorporation.github.io/myMPD";
    description = "A standalone and mobile friendly web mpd client with a tiny footprint and advanced features";
    maintainers = [ lib.maintainers.doronbehar ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
