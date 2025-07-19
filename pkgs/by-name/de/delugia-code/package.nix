{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "delugia-code";
  version = "2404.23";
  src = fetchzip {
    url = "https://github.com/adam7/delugia-code/releases/download/v${finalAttrs.version}/delugia-complete.zip";
    hash = "sha256-Zth2D0Cp6T8Ri+HK9c5JEKYF9OiwHS3EqKiulaKMMio=";
  };
  installPhase = ''
    runHook preInstall
    install -m444 -Dt $out/share/fonts *.ttf
    runHook postInstall
  '';
  meta = {
    description = "Cascadia Code with Nerd Fonts";
    homepage = "https://github.com/adam7/delugia-code";
    changelog = "https://github.com/adam7/delugia-code/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.evythedemon ];
    platforms = lib.platforms.all;
  };
})
