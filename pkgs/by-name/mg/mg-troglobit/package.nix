{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mg-troglobit";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "mg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uRuCDzIDO/+GhEufPP1TGhhbZ29PJ/KrZGGuIfc7B0Q=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  enableParallelBuilding = true;

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Micro (GNU) Emacs-like text editor";
    homepage = "https://github.com/troglobit/mg";
    maintainers = with lib.maintainers; [ cve ];
    license = lib.licenses.publicDomain;
    mainProgram = "mg";
    platforms = lib.platforms.all;
  };
})
