{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "errbot-plugin-xmppbridge-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "errbot-xmppbridge";
    rev = version;
    sha256 = "0lilkg9nfavw7blfj4qp5sngm459b8ngzy4zqlh41wmkm89czz0v";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp xmppbridge.{plug,py} $out
  '';

  meta = with stdenv.lib; {
    description = "An errbot plugin to bridge chatrooms to an XMPP server";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
