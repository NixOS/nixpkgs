{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "find_facts_web";
  version = "20251022";

  outputs = [
    "out"
    "settings"
  ];

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/find_facts_web-${finalAttrs.version}.tar.gz";
    hash = "sha256-BUJ13297nR2qO13ZKjyhGE+5vHU5i3WvNRt7nPqAipw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/web
    install -m644 web/* $out/share/web

    mkdir -p $settings/etc
    substitute etc/settings $settings/etc/settings \
      --replace-fail '$COMPONENT' "$out/share"

    runHook postInstall
  '';

  meta = {
    description = "Assets for the Find_Facts web app";
    homepage = "https://isabelle.in.tum.de/";
    license = lib.licenses.AND [
      # For material-components-web-elm
      lib.licenses.mit
      # For roboto font
      lib.licenses.ofl
      # For Find_Facts (part of isabelle)
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.all;
  };
})
