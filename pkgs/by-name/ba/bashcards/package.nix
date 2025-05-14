{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bashcards";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rpearce";
    repo = "bashcards";
    rev = "v${version}";
    sha256 = "1rpqrh0022sbrjvd55a0jvpdqhhka5msf8dsz6adbbmxy3xzgdid";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    cp bashcards.8 $out/share/man/man8/
    cp bashcards $out/bin/
  '';

  meta = with lib; {
    description = "Practice flashcards in bash";
    homepage = "https://github.com/rpearce/bashcards/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rpearce ];
    platforms = platforms.all;
    mainProgram = "bashcards";
  };
}
