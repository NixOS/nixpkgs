{ lib
, fetchFromGitHub
, xmrig
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.22.1-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-CwGHSrnxzKCLKJC7MmqWATqTUNehhRECcX4g/e9oGSI=";
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
