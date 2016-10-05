{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "xmpp-client-${version}";
  version = "20160916-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "abbf9020393e8caae3e8996a16ce48446e31cf0e";

  goPackagePath = "github.com/agl/xmpp-client";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "xmpp-client";
    inherit rev;
    sha256 = "0j9mfr208cachzm39i8b94v5qk9hws278vv2ms9ma4wn16wns81s";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "An XMPP client with OTR support";
    homepage = https://github.com/agl/xmpp-client;
    license = licenses.bsd3;
    maintainers = with maintainers; [ codsl ];
  };
}
