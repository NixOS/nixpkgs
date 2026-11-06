{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "solr";
  version = "9.9.0";

  outputs = [
    "out"
    "settings"
  ];

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/solr-${finalAttrs.version}.tar.gz";
    hash = "sha256-/njaMplSwjuEr7LOsHsMeM8np7EMoS2BKRJp6qg0QQg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/*.jar $out/lib

    mkdir -p $settings/etc
    substitute etc/settings $settings/etc/settings \
      --replace-fail '$COMPONENT' "$out"

    runHook postInstall
  '';
})
