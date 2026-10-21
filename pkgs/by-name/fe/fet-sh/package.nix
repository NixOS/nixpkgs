{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fet-sh";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "eepykate";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "sha256-xhX2nVteC3T3IjQh++mYlm0btDJQbyQa6b8sGualV0E=";
  };

  postPatch = ''
    patchShebangs fet.sh
  '';

  installPhase = ''
    install -m755 -D fet.sh $out/bin/fet.sh
  '';

  meta = {
    description = "Fetch written in posix shell without any external commands";
    homepage = "https://github.com/eepykate/fet.sh";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ elkowar ];
    mainProgram = "fet.sh";
  };
}
