{
  stdenv,
  undmg,
  fetchurl,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmux";
  version = "0.60.0";

  src = fetchurl {
    url = "https://github.com/manaflow-ai/cmux/releases/download/v${finalAttrs.version}/cmux-macos.dmg";
    hash = "sha256-aIy/4dJSE7kl3VH1OpdtU1fqToac+LeLx/5qZF8CpbY=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Ghostty-based macOS terminal with vertical tabs and notifications for AI coding agents";
    homepage = "https://www.cmux.dev";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ shunueda ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
