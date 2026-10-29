{
  stdenv,
  lib,
  fetchFromGitHub,
  libcap,
  acl,
  file,
  readline,
  python3,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clifm";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "leo-arch";
    repo = "clifm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dzbrKxXp+Vay7aT0KeDGP76uOgFibN7w7+RUEQF+S38=";
  };

  buildInputs = [
    libcap
    acl
    file
    readline
    python3
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DATADIR=${placeholder "out"}/share"
  ];

  enableParallelBuilding = true;

  nativeCheckInputs = [ versionCheckHook ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/leo-arch/clifm";
    changelog = "https://github.com/leo-arch/clifm/releases/tag/v${finalAttrs.version}";
    description = "CLI-based, shell-like, and non-curses terminal file manager";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nadir-ishiguro ];
    platforms = lib.platforms.unix;
    mainProgram = "clifm";
  };
})
