{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-bright";
  version = "5.528";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwBright/releases/download/v${finalAttrs.version}/LXGWBright.7z";
    hash = "sha256-pHa6liDc4Pu6dSL+V47VzHuhRRg2NhKvWD/gfqM5c+o=";
  };

  nativeBuildInputs = [ p7zip ];
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    7z x $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    find . -name "*.ttf" -exec install -m644 {} $out/share/fonts/truetype/ \;
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/lxgw/LxgwBright";
    description = "A merged font of Ysabeau and LXGW WenKai.";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
