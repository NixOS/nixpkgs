{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "inform6";
  version = "6.42-r9";

  src = fetchurl {
    url = "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-${version}.tar.gz";
    sha256 = "sha256-aHYjqjdISnyUxtruDDWD0cHEOxBpvm3+TfNxtGofezQ=";
  };

  buildInputs = [ perl ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Interactive fiction compiler and libraries";
    longDescription = ''
      Inform 6 is a C-like programming language for writing interactive fiction
      (text adventure) games.
    '';
    homepage = "https://gitlab.com/DavidGriffith/inform6unix";
    changelog = "https://gitlab.com/DavidGriffith/inform6unix/-/raw/${version}/NEWS";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ ddelabru ];
    platforms = lib.platforms.all;
  };
}
