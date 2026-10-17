{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kanata-config-aekeynox";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kanata-config-aekeynox";
    tag = finalAttrs.version;
    hash = "sha256-P2Ogi5xyRCzLEtf0UwTDX2BfTmoJRFz+JI32ONcjeVA=";
  };

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kanata-config-aekeynox
    cp -r defcfg defsrc deflayer defalias $out/share/kanata-config-aekeynox

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kanata implementation of the Arsenik keymap";
    homepage = "https://github.com/OneDeadKey/kanata-config-aekeynox";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      nim65s
      severindupouy
    ];
    platforms = lib.platforms.all;
  };
})
