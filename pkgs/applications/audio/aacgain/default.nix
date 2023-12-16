{ lib
, stdenv
, fetchFromGitHub
, cmake
, autoconf
, automake
, libtool
, mp4v2
}:

stdenv.mkDerivation rec {
  pname = "aacgain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = pname;
    rev = version;
    hash = "sha256-842+ueBSrTRs/e14d2LUd+uFi2qgJOYv+dswpC0lgIo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm -rf 3rdparty/mp4v2/*
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
