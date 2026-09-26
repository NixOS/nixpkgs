{
  scala_3,
  fetchurl,
}:

scala_3.bare.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "3.3.4";

    outputs = [
      "out"
      "settings"
    ];

    src = fetchurl {
      url = "https://isabelle.in.tum.de/components/scala-${finalAttrs.version}.tar.gz";
      hash = "sha256-qWhl7Z7v8ll1y8brUsNGmehQ4pmOmqxReEWAEFW3TC0=";
    };

    postPatch = ''
      rm LICENSE README VERSION
    '';

    postInstall = ''
      mkdir -p $settings/etc
      substitute $out/etc/settings $settings/etc/settings \
        --replace-fail '$COMPONENT' "$out"
      rm -rf $out/etc
    '';
  }
)
