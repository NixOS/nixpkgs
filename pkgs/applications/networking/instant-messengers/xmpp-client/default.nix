{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "xmpp-client-${version}";
  version = "20160110-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "525bd26cf5f56ec5aee99464714fd1d019c119ff";

  goPackagePath = "github.com/agl/xmpp-client";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/agl/xmpp-client";
    sha256 = "0a1r08zs723ikcskmn6ylkdi3frcd0i0lkx30i9q39ilf734v253";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    description = "An XMPP client with OTR support";
    homepage = https://github.com/agl/xmpp-client;
    license = licenses.bsd3;
    maintainers = with maintainers; [ codsl ];
  };
}
