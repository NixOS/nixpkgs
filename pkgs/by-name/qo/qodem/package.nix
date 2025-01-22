{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
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

  patches = [
    # Fix ICH with count>1
    # https://gitlab.com/AutumnMeowMeow/qodem/-/issues/77
    (fetchpatch2 {
      url = "https://gitlab.com/-/project/6684464/uploads/c2ceaef82d483c13ff9ec64424f3c40a/0001-Fix-ICH-with-count-1.patch";
      hash = "sha256-lCqj4p8onUS4pehQMXS6lbC7JH5dP6sOjDALpasgd2M=";
    })

    # Don't clear line rendition on partial ED
    # https://gitlab.com/AutumnMeowMeow/qodem/-/issues/78
    (fetchpatch2 {
      url = "https://gitlab.com/-/project/6684464/uploads/462c0b1cf05c3fc2857ce982e62fefcc/0001-Don-t-clear-line-rendition-on-partial-ED.patch";
      hash = "sha256-lSuxP0tUfGa3BjK3ehpdMi16XaGZrdVvAcM2vnjAme8=";
    })

    # DECCOLM should clear line rendition attributes
    # https://gitlab.com/AutumnMeowMeow/qodem/-/issues/78
    (fetchpatch2 {
      url = "https://gitlab.com/-/project/6684464/uploads/812bdfdfaee44eed346fcff85f53efbe/0002-DECCOLM-should-clear-line-rendition-attributes.patch";
      hash = "sha256-XO+h5fpBTLLYC3t4FRCy1uFiMkmSXbre4T2NB/FC3uQ=";
    })

    # Fix build with miniupnpc 2.2.8
    ./qodem-fix-miniupnpc-2.2.8.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs =
    [
      ncurses
      SDL
      miniupnpc
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform gpm) [
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
