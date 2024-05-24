{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-place-names";
  version = "0-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-place-names";
    rev = "8ddc00b0a8e0f3dc822a1008f0d62d1f59929025";
    hash = "sha256-nkzppZtNsSfgiC7kCTJkGfwqAfK/TYunz9Z5tE1N5s8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-place-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

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
