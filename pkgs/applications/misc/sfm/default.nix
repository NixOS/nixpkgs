{ lib, stdenv, fetchFromGitHub, writeText, conf ? null }:

stdenv.mkDerivation rec {
  pname = "sfm";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "afify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NmafUezwKK9bYPAWDNhegyjqkb4GY/i1WEtQ9puIaig=";
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
