{stdenv, fetchhg}:
let
  s =
  rec {
    baseName = "slmenu";
    version = "hg-${date}";
    date = "2012-02-01";
    name = "${baseName}-${version}";
    url = "https://bitbucket.org/rafaelgg/slmenu/";
    rev = "7e74fa5db73e8b018da48d50dbbaf11cb5c62d13";
    sha256 = "0zb7mm8344d3xmvrl62psazcabfk75pp083jqkmywdsrikgjagv6";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchhg {
    inherit (s) url sha256;
  };
  makeFlags = [ "PREFIX=$(out)" ];
  meta = {
    inherit (s) version;
    description = ''A console dmenu-like tool'';
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
