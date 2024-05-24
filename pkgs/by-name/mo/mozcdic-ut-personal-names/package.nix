{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-personal-names";
  version = "0-unstable-2024-08-06";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-personal-names";
    rev = "79e1192de922bba74ce45f59fd591f1cd9a061f5";
    hash = "sha256-5cfoeQS7H4uMRi7CQGFwdwDetihWKNVdFdON+/syvDA=";
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
