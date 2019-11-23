{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.11";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "0if5nh4m4y3xlvlv86jph7ix5nvpgc1zjkp4cq5iig6z0041bw98";
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
