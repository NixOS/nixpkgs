{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  name = "glowing-bear-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "glowing-bear";
    repo = "glowing-bear";
    sha256 = "0gwrf67l3i3nl7zy1miljz6f3vv6zzc3g9as06by548f21cizzjb";
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
