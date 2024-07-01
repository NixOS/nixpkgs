{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-personal-names";
  version = "0-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-personal-names";
    rev = "1d30d6637127fd65a827dc8f52e40f1ed7af0e1d";
    hash = "sha256-mPzYWk4XpJCig3owVOwizTXws9zSJ5E3HdKHyGgQkXc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-personal-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT Personal Name Dictionary is a dictionary for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-personal-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
