{ lib
, fetchFromGitHub
, xmrig
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.22.0-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-sojzyMC4+x6SyhcaWNzS+IFpqobrzpQB6Kwc2ybO5Dk=";
  };

  meta = with lib; {
    description = "Fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = platforms.unix;
    maintainers = with maintainers; [ j0hax redhawk ];
  };
})
