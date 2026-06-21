{
  autoreconfHook,
  fetchFromGitea,
  gitMinimal,
  lib,
  nix-update-script,
  stdenvNoCC,
  zsh,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bum";
  version = "2.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "waterkip";
    repo = "bum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iqfj1jYgqK/OpWjyovS+amisvKeGB5dVf1l1ous2/lQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gitMinimal
    zsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://codeberg.org/waterkip/bum/src/tag/${finalAttrs.src.tag}/Changes";
    description = "Collection of scripts and aliases working with git";
    homepage = "https://codeberg.org/waterkip/bum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
