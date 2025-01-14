{
  lib,
  stdenv,
  byacc,
  fetchFromSourcehut,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pc";
  version = "0.4";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "pc";
    rev = finalAttrs.version;
    hash = "sha256-fzEDI20o5ROY9n/QRzCW66iCKYaBbI++Taur6EoA0wA=";
  };

  nativeBuildInputs = [ byacc ];
  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Programmer's calculator";
    homepage = "https://git.sr.ht/~ft/pc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.unix;
    mainProgram = "pc";
  };
})
