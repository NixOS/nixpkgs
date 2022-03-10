{ fetchFromGitHub, lib, xmrig }:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.16.4-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-OnKz/Sl/b0wpZ1tqeEXhNxNNmQJXBhv5YNnKu9aOVZA=";
  };

  meta = with lib; {
    description = "A fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ j0hax ];
  };
})
