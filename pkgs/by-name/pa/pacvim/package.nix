{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "pacvim";
  version = "1.1.1-unstable-2018-05-16";

  src = fetchFromGitHub {
    owner = "jmoon018";
    repo = "PacVim";
    rev = "ca7c8833c22c5fe97974ba5247ef1fcc00cedb8e";
    hash = "sha256-osMq5LqtmITCzU3DLJatSWexJn2eGiICdbhQXfuRBs8=";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #   https://github.com/jmoon018/PacVim/pull/53
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/jmoon018/PacVim/commit/760682824cdbb328af616ff43bf822ade23924f7.patch";
      hash = "sha256-z0RykcydY5GWOzy4MrJCEp++6AITxwtxo25awRoSafg=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Game that teaches you vim commands";
    homepage = "https://github.com/jmoon018/PacVim";
    mainProgram = "pacvim";
    maintainers = with lib.maintainers; [ iedame ];
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
}
