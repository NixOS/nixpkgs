{ stdenv, fetchFromGitHub, lib, xmrig }:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
  version = "6.18.1-mo1";

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-ZHSDJLZ+5WTqJwSWT05VuN7VAK/aD0dimVFiZ39IWvg=";
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
