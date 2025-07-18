{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chicago95";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "grassmunk";
    repo = "Chicago95";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EHcDIct2VeTsjbQWnKB2kwSFNb97dxuydAu+i/VquBA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Theme/Chicago95 $out/share/themes
    runHook postInstall
  '';

  meta = {
    description = "Rendition of everyone's favorite 1995 Microsoft operating system for Linux";
    homepage = "https://github.com/grassmunk/Chicago95";
    changelog = "https://github.com/grassmunk/Chicago95/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus # generally
      mit # for the lightdm greeter
    ];
    maintainers = with lib.maintainers; [
      linuxissuper
      jk
    ];
    platforms = lib.platforms.all;
  };
})
