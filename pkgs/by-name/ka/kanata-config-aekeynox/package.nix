{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kanata-config-aekeynox";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kanata-config-aekeynox";
    rev = "b3dde3efd9f52e768f187a6debf752d24956f41e";
    hash = "sha256-/dxcHbew3COIDUMT1PFYLTtdKYTWTpGX5sLDwWZ3ZQw=";
  };

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kanata-config-aekeynox
    cp -r defsrc deflayer defalias $out/share/kanata-config-aekeynox

    runHook postInstall
  '';

  meta = {
    description = "Kanata implementation of the Arsenik keymap";
    homepage = "https://github.com/OneDeadKey/kanata-config-aekeynox";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
