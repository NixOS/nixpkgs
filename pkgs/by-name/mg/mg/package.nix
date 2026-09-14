{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mg";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "mg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ja6z/aFdsdlqAoWsevCOUySIE8At4yS3wsmDbjbU0dk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;
  strictDeps = true;
  __structuredAttrs = true;

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
