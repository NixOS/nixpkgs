{ lib, stdenv, fetchFromGitHub, makeWrapper, git, gnused }:

stdenv.mkDerivation rec {
  pname = "git-reparent";
  version = "unstable-2017-09-03";

  src = fetchFromGitHub {
    owner  = "MarkLodato";
    repo   = "git-reparent";
    rev    = "a99554a32524a86421659d0f61af2a6c784b7715";
    sha256 = "0v0yxydpw6r4awy0hb7sbnh520zsk86ibzh1xjf3983yhsvkfk5v";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-reparent
  '';

  postFixup = ''
    wrapProgram $out/bin/git-reparent --prefix PATH : "${lib.makeBinPath [ git gnused ]}"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Git command to recommit HEAD with a new set of parents";
    maintainers = [ ];
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "git-reparent";
  };
}
