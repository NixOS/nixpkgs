{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "11bwajzidnyagdyip7i8rwni1f66acv0k4lybdm0mc4195anivjh";
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
    maintainers = with maintainers; [ fpletz lheckemann ];
  };
}
