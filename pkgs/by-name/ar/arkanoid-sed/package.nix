{
  lib,
  stdenvNoCC,
  fetchurl,
  gnused,
  makeWrapper,
}:

stdenvNoCC.mkDerivation {
  pname = "arkanoid-sed";
  version = "1.2";

  src = fetchurl {
    url = "http://sed.sourceforge.net/local/games/arkanoid.sed";
    hash = "sha256-NzqlTdr8jT1O7OPTShdaFfeZsNKyjjIU6vyb6zz8wno=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src" "$out/share/arkanoid-sed/arkanoid.sed"

    makeWrapper ${gnused}/bin/sed "$out/bin/arkanoid-sed" \
      --add-flags "-nf $out/share/arkanoid-sed/arkanoid.sed" \
      --run 'if [ -t 0 ]; then printf "Press ENTER to start\n" >&2; fi'

    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    output="$(printf "\n1\nq\n" | "$out/bin/arkanoid-sed")"
    grep -Fq "Welcome to the SED Arkanoid" <<<"$output"
    ! grep -Fq "there is no" <<<"$output"

    runHook postInstallCheck
  '';

  meta = {
    description = "Arkanoid game written in SED";
    homepage = "https://aurelio.net/projects/sedarkanoid/";
    license = lib.licenses.gpl2Only;
    mainProgram = "arkanoid-sed";
    maintainers = with lib.maintainers; [ Zaczero ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
