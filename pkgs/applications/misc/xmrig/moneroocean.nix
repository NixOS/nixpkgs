{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, xmrig
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.21.0-mo2";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-OKyJcmhlY8gfDKyBf83KHhokp4qA8EDyessTwKReaD8=";
  };

  patches = [
    # Fix build against gcc-13 due to missing <stdexcept> include
    #   https://github.com/MoneroOcean/xmrig/pull/123
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/MoneroOcean/xmrig/commit/7d3ea51d68049c35e9d4c75732c751eefbc5ab29.patch";
      hash = "sha256-iNrtZ8LxNJMzn8kXLhYGEFAy0ughfOZobDVRImpVPC0=";
    })
  ];

  meta = with lib; {
    description = "Fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = platforms.unix;
    maintainers = with maintainers; [ j0hax ];
  };
})
