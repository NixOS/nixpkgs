{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.15";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "0lib2qlc8a59i9dak0g1j5hymwbq9vhflp5srhcjislxypfvrizs";
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
