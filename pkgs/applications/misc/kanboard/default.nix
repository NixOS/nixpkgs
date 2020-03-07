{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "0mm5sx323v1rwykd1dhvk4d3ipgvgvi3wvhrlavbja3lgay3mdwk";
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
    maintainers = with maintainers; [ fpletz lheckemann ];
  };
}
