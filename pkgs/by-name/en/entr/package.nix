{
  lib,
  stdenv,
  fetchurl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "5.7";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/entr-${version}.tar.gz";
    hash = "sha256-kMXZQ4IMcM7zfrQaOCpupPXdf9le/vE7K1Ug0yD10Gc=";
  };

  postPatch = ''
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.1 --replace /bin/cat cat
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  TARGET_OS = stdenv.hostPlatform.uname.system;

  meta = {
    homepage = "https://eradman.com/entrproject/";
    description = "Run arbitrary commands when files change";
    changelog = "https://github.com/eradman/entr/raw/${version}/NEWS";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pSub
      synthetica
    ];
    mainProgram = "entr";
  };
}
