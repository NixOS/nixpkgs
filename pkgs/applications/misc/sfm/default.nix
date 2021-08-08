{ lib, stdenv, fetchFromGitHub, writeText, conf ? null }:

stdenv.mkDerivation rec {
  pname = "sfm";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "afify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DwXKrSqcebNI5N9REXyMV16W2kr72IH9+sKSVehc5zw=";
  };

  configFile = lib.optionalString (conf!=null) (writeText "config.def.h" conf);

  postPatch = lib.optionalString (conf!=null) "cp ${configFile} config.def.h";

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple file manager";
    homepage = "https://github.com/afify/sfm";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
