{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "biz-ud-gothic";
  version = "1.051";

  src = fetchzip {
    # Sticking with this assets file due to ongoing discussions.
    # We may switch to a different asset once the issue is resolved or clarifications are provided.
    # ref: https://github.com/googlefonts/morisawa-biz-ud-gothic/issues/47
    url = "https://github.com/googlefonts/morisawa-biz-ud-gothic/releases/download/v${finalAttrs.version}/morisawa-biz-ud-gothic-fonts.zip";
    hash = "sha256-7PlIrQX1fnFHXm7mjfoOCVp3GSnLT2GlVZdSoZbh/s4=";
  };

  sourceRoot = "${finalAttrs.src.name}/fonts";

  nativeBuildInputs = [ installFonts ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Universal Design Japanese font";
    homepage = "https://github.com/googlefonts/morisawa-biz-ud-gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      kachick
    ];
    platforms = lib.platforms.all;
  };
})
