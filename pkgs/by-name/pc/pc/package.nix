{
  lib,
  stdenv,
  byacc,
  fetchFromSourcehut,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pc";
  version = "0.6";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "pc";
    rev = finalAttrs.version;
    hash = "sha256-hmFzFaBMb/hqKqc+2hYda1+iowWhs/pC+6LPPhhqzJo=";
  };

  nativeBuildInputs = [ byacc ];
  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=implicit-function-declaration"
    ]
  );

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
