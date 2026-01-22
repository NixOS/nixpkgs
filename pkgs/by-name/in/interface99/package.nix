{
  fetchFromGitHub,
  lib,
  metalang99,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "interface99";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "interface99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hl5QQbuIP7on4GSNQISSP0uC80qs6S9M2YXVt3EPW84=";
  };

  dontBuild = true;

  propagatedBuildInputs = [ metalang99 ];

  installPhase = ''
    runHook preInstall

    install -Dm644 interface99.h --target-directory="$out"/include

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured interfaces for C99";
    longDescription = ''
      Full-featured interfaces inspired by Rust and Golang.  Multiple
      inheritance, superinterfaces, and default implementations
      supported.  No external tools required, pure C99.
    '';
    homepage = "https://github.com/hirrolot/interface99";
    changelog = "https://github.com/hirrolot/interface99/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
