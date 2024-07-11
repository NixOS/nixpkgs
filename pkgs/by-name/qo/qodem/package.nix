{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
  SDL,
  gpm,
  miniupnpc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qodem";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "klamonte";
    repo = "qodem";
    rev = "v${finalAttrs.version}";
    sha256 = "NAdcTVmNrDa3rbsbxJxFoI7sz5NK5Uw+TbP+a1CdB+Q=";
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
    maintainers = with lib.maintainers; [ embr ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
})
