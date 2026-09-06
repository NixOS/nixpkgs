{
  stdenv,
  lib,
  fetchFromGitLab,
  ncurses,
  pkg-config,
  nix-update-script,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbonsai";
  version = "1.4.2";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = "cbonsai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TZb/5DBdWcl54GoZXxz2xYy9dXq5lmJQsOA3C26tjEU=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    scdoc
  ];
  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grow bonsai trees in your terminal";
    homepage = "https://gitlab.com/jallbrit/cbonsai";
    license = lib.licenses.gpl3Only;
    mainProgram = "cbonsai";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.unix;
  };
})
