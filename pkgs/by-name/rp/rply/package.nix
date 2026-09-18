{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rply";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "diegonehab";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-WkUgb6WeYp1OpV3/+EcEJkxEXYP0e7inQZQM87tGOGo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    gcc -c -fPIC -o rply.o rply.c
    gcc -shared -o librply.so rply.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include
    cp -t $out/lib librply.so
    cp -t $out/include rply.h

    runHook postInstall
  '';

  meta = {
    description = "ANSI C Library for PLY file format input and output";
    homepage = "https://github.com/diegonehab/rply";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
