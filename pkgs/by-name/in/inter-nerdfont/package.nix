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
    homepage = "https://gitlab.com/mid_os/inter-nerdfont";
    description = "NerdFont patch of the Inter font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.midischwarz12 ];
  };
}
