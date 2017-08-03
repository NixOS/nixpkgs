{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "kanboard-${version}";
  version = "1.0.44";

  src = fetchzip {
    url = "https://kanboard.net/${name}.zip";
    sha256 = "1cwk9gcwddwbbw6hz2iqmkmy90rwddy79b9vi6fj9cl03zswypgn";
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
