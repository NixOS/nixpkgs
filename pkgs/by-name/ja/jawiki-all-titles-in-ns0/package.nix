{ lib
, fetchurl
, stdenvNoCC
}:

let
date = "20240520";
jawiki = fetchurl {
  url ="https://dumps.wikimedia.org/jawiki/${date}/jawiki-${date}-all-titles-in-ns0.gz";
  hash= "sha256-HMQutYuKiI7fXmbivS0mIgdHsQu6t6WdVFVrnyw8JIw=";
};
in stdenvNoCC.mkDerivation {
  pname = "jawiki-all-titles-in-ns0";
  version = "0-unstable-${date}";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ${jawiki} $out/jawiki-all-titles-in-ns0.gz

    runHook postInstall
  '';

  meta = {
    description = "A jawiki dump list of page titles in main namespace";
    homepage = "https://dumps.wikimedia.org/backup-index.html";
    license = with lib.licenses;[ fdl13Only cc-by-sa-30 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides a dump gz file
    hydraPlatforms = [ ];
  };
}
