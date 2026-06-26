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
  version = "1.2.52";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iI9Dyno1s9P9t7IxfDs5gQUl9yFyu2taXvKY0WnF2Q0=";
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
