{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "exam-monitor";
  version = "24044";

  src = fetchurl {
    url = "https://login.exammonitor.dk/exam.jar";
    sha256 = "0kb07m1r8p71ipzvwv2armfm68g2pnbnf0m724ldwf0jk665x285";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/exam.jar
    makeWrapper ${jre}/bin/java $out/bin/exam-monitor \
      --add-flags "-Dhttp.agent=EM/ -Dapple.eawt.quitStrategy=CLOSE_ALL_WINDOWS -Xms64m -Xmx512m -jar $out/share/java/exam.jar SDU"
  '';

  meta = with lib; {
    homepage = "https://sdu.exammonitor.dk/";
    description =
      "A tool used for monitoring of students during exams at the University of Southern Denmark";
    mainProgram = "exam-monitor";
    platforms = platforms.unix;
    license = licenses.unfree;
    maintainers = with maintainers; [ xdhampus ];
  };
}
