{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "0k45vfiacvwmrglpqwjq22pvdg4n0mf75x0r8nb79bmxp8sk0j0c";
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
