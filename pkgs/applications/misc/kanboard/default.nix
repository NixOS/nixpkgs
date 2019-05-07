{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "kanboard-${version}";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "1hdr95cpxgdzrzhffs63gdl0g7122ma2zg8bkqwp42p5xphx0xan";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard
  '';

  meta = with stdenv.lib; {
    description = "Kanban project management software";
    homepage = https://kanboard.net;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
