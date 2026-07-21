{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "semver-tool";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = "semver-tool";
    rev = finalAttrs.version;
    sha256 = "sha256-BnHuiCxE0VjzMWFTEMunQ9mkebQKIKbbMxZVfBUO57Y=";
  };

  dontBuild = true; # otherwise we try to 'make' which fails.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install src/semver $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/fsaintjacques/semver-tool";
    description = "Semver bash implementation";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.qyliss ];
    mainProgram = "semver";
  };
})
