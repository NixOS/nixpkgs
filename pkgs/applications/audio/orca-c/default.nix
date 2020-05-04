{ stdenv, fetchFromGitHub, ncurses, portmidi }:
stdenv.mkDerivation {
  pname = "orca-c";

  version = "git-2020-02-12";

  src = fetchFromGitHub {
    owner = "hundredrabbits";
    repo = "Orca-c";
    rev = "c6d981d35bb7b93b9b43e1920d45a71f00328dd3";
    sha256 = "00hmjcadv4w0y4ixbys8c6w43lcma48arjhikjr55grz9krlvwqa";
  };

  buildInputs = [ ncurses portmidi ];

  patchPhase = ''
    patchShebangs tool
  '';

  installPhase = ''
    mkdir -p $out/bin
    install build/orca $out/bin/orca
  '';

  meta = with stdenv.lib; {
    description = "An esoteric programming language designed to quickly create procedural sequencers.";
    homepage = "https://github.com/hundredrabbits/Orca-c";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
