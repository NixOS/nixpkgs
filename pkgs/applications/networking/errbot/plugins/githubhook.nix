{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "errbot-plugin-githubhook-${version}";
  version = "2016-09-22";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "err-githubhook";
    rev = "ad0208a4bfdb29a3d2a9ab26751cc8441dc593b0";
    sha256 = "0q2slk1llw4svl2lvfzq4yynz1sn3hc68lpkv4gb6zknqmkqxmrd";
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
