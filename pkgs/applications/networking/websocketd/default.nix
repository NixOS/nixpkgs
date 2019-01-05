{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "websocketd-${version}";
  version = "0.3.0";
  rev = "729c67f052f8f16a0a0aa032816a57649c0ebed3";

  goPackagePath = "github.com/joewalnes/websocketd";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/joewalnes/websocketd";
    sha256 = "1n4fag75lpfxg1pm1pr5v0p44dijrxj59s6dn4aqxirhxkq91lzb";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.bsd2;
  };
}
