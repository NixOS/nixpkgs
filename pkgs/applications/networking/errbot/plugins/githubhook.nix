{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "errbot-plugin-githubhook-${version}";
  version = "2016-09-22";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "err-githubhook";
    rev = "62002e3a5cda408f164146b281ad433707764aa4";
    sha256 = "0as0dc3kbvav2xglzhp595qc2nfm4l2rkgh31kjvzxrj7inns4p9";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp -R githubhook.{plug,py} templates $out
  '';

  meta = with stdenv.lib; {
    description = "Webhook endpoint for Errbot as well as a set of commands to configure the routing of messages to chatrooms";
    license = licenses.gpl3;
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
