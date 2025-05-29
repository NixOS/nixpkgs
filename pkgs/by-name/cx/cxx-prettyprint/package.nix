{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cxx-prettyprint-unstable";
  version = "2016-04-30";
  rev = "9ab26d228f2960f50b38ad37fe0159b7381f7533";

  src = fetchFromGitHub {
    owner = "louisdx";
    repo = "cxx-prettyprint";
    inherit rev;
    sha256 = "1bp25yw8fb0mi432f72ihfxfj887gi36b36fpv677gawm786l7p1";
  };

  installPhase = ''
    mkdir -p "$out/include"
    cp prettyprint.hpp "$out/include"
  '';

  meta = with lib; {
    description = "Header only C++ library for pretty printing standard containers";
    homepage = "https://github.com/louisdx/cxx-prettyprint";
    license = lib.licenses.boost;
    platforms = platforms.all;

    # This is a header-only library, no point in hydra building it:
    hydraPlatforms = [ ];
  };
}
