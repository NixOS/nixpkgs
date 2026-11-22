{
  installFonts,
  inter,
  lib,
  nerd-font-patcher,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "inter-nerdfont";
  inherit (inter) version;

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;

  nativeBuildInputs = [
    installFonts
    nerd-font-patcher
  ];

  buildPhase = ''
    runHook preBuild
    nerd-font-patcher --quiet --complete --careful ${inter}/share/fonts/truetype/Inter.ttc
    nerd-font-patcher --quiet --complete --careful --variable-width-glyphs ${inter}/share/fonts/truetype/Inter.ttc
    runHook postBuild
  '';

  meta = {
    homepage = "https://rsms.me/inter/";
    description = "NerdFont patch of the Inter font";
    license =
      with lib.licenses;
      AND [
        ofl
        mit
        asl20
        cc-by-40
        unlicense
      ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.midischwarz12 ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
