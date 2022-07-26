{ stdenv, fetchFromGitHub, lib, xmrig }:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.16.5-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-TNiHvRLS+eAPHa+qbnVSAyWTPGJxdp9eheQamd4i24E=";
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ j0hax ];
  };
})
