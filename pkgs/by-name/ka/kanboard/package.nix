{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kanboard";
  version = "1.2.47";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LedK1Ct4xz88r4gvN2jxOE/7Yg6rnrnjCHdhmn3tun4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      inherit (nixosTests) kanboard;
    };
  };

  meta = {
    inherit (php.meta) platforms;
    description = "Kanban project management software";
    homepage = "https://kanboard.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
