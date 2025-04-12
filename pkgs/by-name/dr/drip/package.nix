{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk8,
  which,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "drip";
  version = "0.2.4";

  src = fetchFromGitHub {
    repo = pname;
    owner = "ninjudd";
    rev = version;
    sha256 = "1zl62wdwfak6z725asq5lcqb506la1aavj7ag78lvp155wyh8aq1";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jdk8 ];

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp ./* $out -r
    wrapProgram $out/bin/drip \
      --prefix PATH : "${which}/bin"
    $out/bin/drip version
    runHook postInstall
  '';

  meta = with lib; {
    description = "Launcher for the Java Virtual Machine intended to be a drop-in replacement for the java command, only faster";
    license = licenses.epl10;
    homepage = "https://github.com/ninjudd/drip";
    platforms = platforms.linux;
    maintainers = [ maintainers.rybern ];
  };
}
