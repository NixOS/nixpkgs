{ lib, stdenv, fetchFromGitHub, conf ? null }:

stdenv.mkDerivation rec {
  pname = "sfm";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "afify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i4WzYaJKityIt+LPWCbd6UsPBaYoaS397l5BInOXQQA=";
  };

  configFile = lib.optionalString (conf!=null) (lib.writeText "config.def.h" conf);

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
