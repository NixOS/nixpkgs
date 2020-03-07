{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "glowing-bear";
  version = "0.7.2";

  src = fetchFromGitHub {
    rev = version;
    owner = "glowing-bear";
    repo = "glowing-bear";
    sha256 = "14a3fqsmi28g7j3lzk4l4m47p2iml1aaf3514wazn2clw48lnqhw";
  };

  installPhase = ''
    mkdir $out
    cp index.html min.js serviceworker.js webapp.manifest.json $out
    cp -R 3rdparty assets css directives js $out
  '';

  meta = with stdenv.lib; {
    description = "A web client for Weechat";
    homepage = https://github.com/glowing-bear/glowing-bear;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
