{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  conf ? null,
}:

stdenv.mkDerivation rec {
  pname = "sfm";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "afify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VwPux6n+azpR4qDkzZJia95pJJOaFDBBoz6/VwlC0zw=";
  };

  configFile = lib.optionalString (conf != null) (writeText "config.def.h" conf);

  postPatch = lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple file manager";
    homepage = "https://github.com/afify/sfm";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "sfm";
  };
}
