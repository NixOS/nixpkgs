{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "errbot-plugin-githubhook-${version}";
  version = "2016-09-06";

  src = fetchFromGitHub {
    owner = "daenney";
    repo = "err-githubhook";
    rev = "3368cfcc2aa21b5b5563cea1cb877702bada3872";
    sha256 = "0i5z9ilk17xcnmjlpxqfqg57wx8rriqrsp2qd1h9ikbyzhhldf09";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/errbot/plugins/githubhook
    cp -R githubhook.{plug,py} templates $out/share/errbot/plugins/githubhook
  '';

  meta = with stdenv.lib; {
    description = "Webhook endpoint for Errbot as well as a set of commands to configure the routing of messages to chatrooms";
    license = licenses.gpl3;
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
