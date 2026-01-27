{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "apl387";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "dyalog";
    repo = "APL387";
    rev = "60ff47a728ee043f878dc2ed801d53e29fcebe9d";
    hash = "sha256-VyO+7PUYcmmhbFVAW37yvWQLUpt0K/ihA/JGmbt+4Uk=";
  };

  # TODO(@sternenseemann): (re-)build using script.py?
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://dyalog.github.io/APL387/";
    description = "A New APL386 Unicode";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.all;
  };
}
