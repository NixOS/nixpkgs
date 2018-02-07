{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "kanboard-${version}";
  version = "1.0.48";

  src = fetchzip {
    url = "https://github.com/kanboard/kanboard/releases/download/v${version}/${name}.zip";
    sha256 = "0ipyijlfcnfqlz9n20wcnaf9pw404a675x404pm9h2n4ld8x6m5v";
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
