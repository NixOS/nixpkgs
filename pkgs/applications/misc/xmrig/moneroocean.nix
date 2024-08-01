{ lib
, fetchFromGitHub
, xmrig
}:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.21.3-mo15";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-eLI41O7SQUgNHFuMNT4W4pjAGDFe2plXuXmZH8QyCZ0=";
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
