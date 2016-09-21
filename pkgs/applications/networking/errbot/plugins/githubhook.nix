{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "errbot-plugin-githubhook-${version}";
  version = "2016-09-06";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "err-githubhook";
    rev = "cc62f7f55942d3023ec960689fd1aab7ed0dde3a";
    sha256 = "0imwsa2aab7abx9vn0p8mzrsbgydhljkk7491d66lms6lyf7h7lj";
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
