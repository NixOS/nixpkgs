{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  iosevka,
  variant ? "",
}:

let
  name = if lib.hasPrefix "SGr-" variant then variant else "Iosevka" + variant;

  variantHashes = import ./variants.nix;
  validVariants = map (lib.removePrefix "Iosevka") (
    builtins.attrNames (removeAttrs variantHashes [ "Iosevka" ])
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${name}-bin";
  version = "34.2.1";

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${finalAttrs.version}/PkgTTC-${name}-${finalAttrs.version}.zip";
    hash =
      variantHashes.${name} or (throw ''
        No such variant "${variant}" for package iosevka-bin.
        Valid variants are: ${lib.concatStringsSep ", " validVariants}.
      '');
    stripRoot = false;
  };

  nativeBuildInputs = [
    installFonts
  ];

  meta = {
    inherit (iosevka.meta)
      homepage
      downloadPage
      description
      license
      platforms
      ;
    maintainers = with lib.maintainers; [
      astratagem
    ];
  };

  passthru.updateScript = ./update-bin.sh;
})
