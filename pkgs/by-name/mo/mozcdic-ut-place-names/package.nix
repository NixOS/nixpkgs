{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-place-names";
  version = "0-unstable-2024-09-03";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-place-names";
    rev = "4525819546a26fc994d7ca4a2e883fde14bf908c";
    hash = "sha256-oiSBR2QhOYyurftdEn2w6hNK1ucddlvLqGTiZk9G/4k=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-place-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT Place Name Dictionary is a dictionary converted from the Japan Post's ZIP code data for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-place-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
