{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macdown-se";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/eldris-io/macdown-se/releases/download/v${finalAttrs.version}/MacDown-SE-${finalAttrs.version}.dmg";
    hash = "sha256-gYScYvQnRf9SCtqjA+Da+jg+5qPqfChc0kCAvtrLBjE=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -r "MacDown SE.app" "$out/Applications/"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/MacDown SE.app/Contents/SharedSupport/bin/macdown-se" "$out/bin/macdown-se"
    ln -s "$out/bin/macdown-se" "$out/bin/macdown"
    runHook postInstall
  '';

  meta = {
    description = "Open-source Markdown editor for Apple Silicon";
    longDescription = ''
      MacDown SE is the native Apple Silicon continuation of the classic
      native Markdown editor for macOS, featuring built-in Model Context
      Protocol (MCP) server integration and AppKit performance.
    '';
    homepage = "https://github.com/eldris-io/macdown-se";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ jeff-oomu ];
    mainProgram = "macdown-se";
  };
})
