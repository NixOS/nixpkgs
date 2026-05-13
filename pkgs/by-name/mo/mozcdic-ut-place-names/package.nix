{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-place-names";
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-place-names";
    rev = "888a977a3f30451e8f286ef8eaf2f9be169234cb";
    hash = "sha256-UL3ik/CxmRM7m0AXS+UNQEipCDS8pH+AheIMx6xqAaU=";
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
    description = "Dictionary converted from the Japan Post's ZIP code data for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-place-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
