{ lib, stdenv
, fetchurl
, fetchpatch
, pkg-config
, alsa-lib
, audiofile
, libjack2
, liblo
, liboil
, libsamplerate
, libsndfile
, lilv
, lv2
, ncurses
, readline
}:

# TODO: fix python. See configure log.
# fix -Dnullptr=0 cludge below.
# The error is
# /nix/store/*-lilv-0.24.10/include/lilv-0/lilv/lilvmm.hpp:272:53: error: 'nullptr' was not declared in this scope

stdenv.mkDerivation rec {
  pname = "ecasound";
  version = "2.9.3";

  src = fetchurl {
    url = "https://ecasound.seul.org/download/ecasound-${version}.tar.gz";
    sha256 = "1m7njfjdb7sqf0lhgc4swihgdr4snkg8v02wcly08wb5ar2fr2s6";
  };

  patches = [
    # Pull patch pending upstream inclusion for ncurses-6.3:
    #  https://sourceforge.net/p/ecasound/bugs/54/
    (fetchpatch {
      name = "ncursdes-6.3.patch";
      url = "https://sourceforge.net/p/ecasound/bugs/54/attachment/0001-ecasignalview.cpp-always-use-s-style-format-for-prin.patch";
      sha256 = "1x1gsjzd43lh19mhpmwrbq269h56s8bxgyv0yfi5yf0sqjf9vaq0";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    audiofile
    libjack2
    liblo
    liboil
    libsamplerate
    libsndfile
    lilv
    lv2
    ncurses
    readline
  ];

  strictDeps = true;

  CXXFLAGS = "-std=c++11";
  configureFlags = [ "--enable-liblilv" "--with-extra-cppflags=-Dnullptr=0" ];

  postPatch = ''
    sed -i -e '
      s@^#include <readline.h>@#include <readline/readline.h>@
      s@^#include <history.h>@#include <readline/history.h>@
      ' ecasound/eca-curses.cpp
  '';

  meta = {
    description = "Software package designed for multitrack audio processing";
    license = with lib.licenses;  [ gpl2 lgpl21 ];
    homepage = "http://nosignal.fi/ecasound/";
  };
}
