{
  lib,
  stdenv,
  fetchurl,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "entr";
  version = "5.8";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/entr-${finalAttrs.version}.tar.gz";
    hash = "sha256-3Jor3FVrK+kAwdjN9DLeJkkt5a8/+t4ADUv9l/MSK/s=";
  };

  postPatch = ''
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.1 --replace /bin/cat cat
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  env.TARGET_OS = stdenv.hostPlatform.uname.system;

  meta = {
    homepage = "https://eradman.com/entrproject/";
    description = "Run arbitrary commands when files change";
    changelog = "https://github.com/eradman/entr/raw/${finalAttrs.version}/NEWS";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pSub
    ];
    mainProgram = "entr";
  };
})
