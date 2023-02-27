{ stdenv, fetchFromGitHub, lib, xmrig }:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.19.0-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-+J6gl/R9Yi8V2nYNuIH/oyplWi8vzfdamELHjp6iS7c=";
  };

  meta = with lib; {
    description = "A fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ j0hax ];
  };
})
