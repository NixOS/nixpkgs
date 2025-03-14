{
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  ragel,
  pkg-config,
  wrapGAppsHook3,
  lua,
  fetchpatch,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "gpick";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "thezbyg";
    repo = "gpick";
    rev = "v${version}";
    hash = "sha256-Z17YpdAAr2wvDFkrAosyCN6Y/wsFVkiB9IDvXuP9lYo=";
  };

  patches = [
    # gpick/cmake/Version.cmake
    ./dot-version.patch

    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/thezbyg/gpick/pull/227.patch";
      hash = "sha256-qYspUctvlPMEK/c2hMUxYc5EYdG//CBcN2PluTtXiFc=";
    })

    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/gpick/-/raw/0.3-2/buildfix.diff";
      hash = "sha256-DnRU90VPyFhLYTk4GPJoiVYadJgtYgjMS4MLgmpYLP0=";
    })
  ];
  # https://github.com/thezbyg/gpick/pull/227
  postPatch = ''
    sed '1i#include <boost/version.hpp>' -i source/dynv/Types.cpp
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    ragel
    lua
  ];

  meta = with lib; {
    description = "Advanced color picker written in C++ using GTK+ toolkit";
    homepage = "https://www.gpick.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
    mainProgram = "gpick";
  };
}
