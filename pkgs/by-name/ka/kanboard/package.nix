{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
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

  # CVE-2026-56774 / NIXPKGS-2026-2001: scope remember-me session removal to
  # the owning user so a session row can only be deleted by its owner.
  # Remove this patch once upgraded past 1.2.52.
  patches = [
    (fetchpatch {
      url = "https://github.com/kanboard/kanboard/commit/928c68aa2b7c00092dd71084d329b912e229f3d1.patch";
      hash = "sha256-K616dTwAsLJAJMqY+DJjebfi6MV5wSICbd1iy6VynlM=";
    })
  ];

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
