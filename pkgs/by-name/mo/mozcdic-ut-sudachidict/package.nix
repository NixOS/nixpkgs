{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-sudachidict";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-sudachidict";
    rev = "c109f062a6c80e52be4b96adbf4123404b2048d1";
    hash = "sha256-gU8bf0qiz/W7HEPhWBPC+GJzMmgqjcL4gzB80RdhEfY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-sudachidict.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT SudachiDict Dictionary is a dictionary converted from SudachiDict for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = with lib.licenses;[ asl20 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
