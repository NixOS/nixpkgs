{ lib
, stdenv
, fetchFromGitHub
, cmake
, autoconf
, automake
, libtool
, faad2
, mp4v2
}:

stdenv.mkDerivation rec {
  pname = "aacgain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = pname;
    rev = version;
    sha256 = "sha256-9Y23Zh7q3oB4ha17Fpm1Hu2+wtQOA1llj6WDUAO2ARU=";
  };

  postPatch = ''
    cp -R ${faad2.src}/* 3rdparty/faad2
    cp -R ${mp4v2.src}/* 3rdparty/mp4v2
    chmod -R +w 3rdparty
  '';

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  meta = with lib; {
    description = "ReplayGain for AAC files";
    homepage = "https://github.com/dgilman/aacgain";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.robbinch ];
  };
}
