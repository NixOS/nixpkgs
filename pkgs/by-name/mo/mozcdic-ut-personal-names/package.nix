{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-personal-names";
  version = "0-unstable-2024-09-21";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-personal-names";
    rev = "b61a5af7992d6fcdc82fa08b67b1c9771bbc4449";
    hash = "sha256-xcfhfO5GIiOVxLfqX3izLHYuSFZCgOlbQE3N3U+HTW4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-personal-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

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
