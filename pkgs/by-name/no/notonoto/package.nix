{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "notonoto";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "yuru7";
    repo = "NOTONOTO";
    rev = "refs/tags/v${version}";
    hash = "sha256-1dbx4yC8gL41OEAE/LNDyoDb4xhAwV5h8oRmdlPULUo=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/notonoto {} \;

    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines Noto Sans Mono and Noto Sans JP";
    homepage = "https://github.com/yuru7/NOTONOTO";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "notonoto";
  };

}
