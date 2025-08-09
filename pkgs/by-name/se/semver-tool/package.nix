{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "semver-tool";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "fsaintjacques";
    repo = "semver-tool";
    rev = version;
    sha256 = "sha256-BnHuiCxE0VjzMWFTEMunQ9mkebQKIKbbMxZVfBUO57Y=";
  };

  dontBuild = true; # otherwise we try to 'make' which fails.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install src/semver $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/fsaintjacques/semver-tool";
    description = "Semver bash implementation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.qyliss ];
    mainProgram = "semver";
  };
}
