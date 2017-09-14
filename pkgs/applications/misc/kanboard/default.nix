{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "kanboard-${version}";
  version = "1.0.46";

  src = fetchzip {
    url = "https://kanboard.net/${name}.zip";
    sha256 = "00fzzijibj7x8pz8xwc601fcrzvdwz5fv45f2zzmbygl86khp82a";
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
