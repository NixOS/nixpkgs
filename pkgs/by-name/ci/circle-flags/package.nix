{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "circle-flags";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "HatScripts";
    repo = "circle-flags";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/+f5MDRW+tRH+jMtl3XuVPBShgy2PlD3NY+74mJa2Qk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv flags $out/share/circle-flags-svg

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/HatScripts/circle-flags";
    description = "Collection of 400+ minimal circular SVG country and state flags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bobby285271 ];
    platforms = lib.platforms.all;
  };
})
