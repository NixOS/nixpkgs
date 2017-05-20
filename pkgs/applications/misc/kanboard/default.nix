{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "kanboard-${version}";
  version = "1.0.40";

  src = fetchzip {
    url = "https://kanboard.net/kanboard-1.0.40.zip";
    sha256 = "1phn3rvngch636g00rhicl0225qk6gdmxqjflkrdchv299zysswd";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard
  '';

  meta = with stdenv.lib; {
    description = "Kanban project management software";
    homepage = "https://kanboard.net";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
