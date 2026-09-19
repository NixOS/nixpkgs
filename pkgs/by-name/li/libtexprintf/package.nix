{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtexprintf";
  version = "1.31";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library providing printf-style formatted output routines with tex-like syntax support";
    homepage = "https://github.com/bartp5/libtexprintf";
    changelog = "https://github.com/bartp5/libtexprintf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ambossmann ];
    mainProgram = "libtexprintf";
    platforms = lib.platforms.all;
  };
})
