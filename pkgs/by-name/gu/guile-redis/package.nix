{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-redis";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "aconchillo";
    repo = "guile-redis";
    tag = finalAttrs.version;
    hash = "sha256-0lObXRBn4yZi2S+MeesT1Z/vJWb907BHknA4hOQOYzE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
  ];

  buildInputs = [ guile ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Redis module for Guile";
    homepage = "https://github.com/aconchillo/guile-redis";
    changelog = "https://github.com/aconchillo/guile-redis/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = guile.meta.platforms;
  };
})
