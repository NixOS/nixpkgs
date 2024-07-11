{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  ncurses,
  SDL,
  gpm,
  miniupnpc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qodem";
  version = "1.0.1-unstable-2022-02-12";

  src = fetchFromGitLab {
    owner = "AutumnMeowMeow";
    repo = "qodem";
    rev = "69cc7458ef23243f790348a4cc503a8173008e55";
    hash = "sha256-Ocb2inuxeDOfqge+h7pHL9I9Kn72Mgi8Eq179/58alk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    ncurses
    SDL
    miniupnpc
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform gpm) [
    gpm
  ];

  configureFlags = lib.optionals (!(lib.meta.availableOn stdenv.hostPlatform gpm)) [
    "--disable-gpm"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  __structuredAttrs = true;

  meta = {
    homepage = "https://qodem.sourceforge.net/";
    description = "Re-implementation of the DOS-era Qmodem serial communications package";
    longDescription = ''
      Qodem is a from-scratch clone implementation of the Qmodem
      communications program made popular in the days when Bulletin Board
      Systems ruled the night. Qodem emulates the dialing directory and the
      terminal screen features of Qmodem over both modem and Internet
      connections.
    '';
    changelog = "${finalAttrs.src.meta.homepage}-/blob/${finalAttrs.src.rev}/ChangeLog";
    maintainers = with lib.maintainers; [ embr ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
})
