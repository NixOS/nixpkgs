{ stdenv, fetchFromGitHub, makeWrapper
, flac, sox }:

stdenv.mkDerivation rec {
  pname = "redoflacs";
  version = "0.30.20150202";

  src = fetchFromGitHub {
    owner  = "sirjaren";
    repo   = "redoflacs";
    rev    = "86c6f5becca0909dcb2a0cb9ed747a575d7a4735";
    sha256 = "1gzlmh4vnf2fl0x8ig2n1f76082ngldsv85i27dv15y2m1kffw2j";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin redoflacs
    install -Dm644 -t $out/share/doc/redoflacs LICENSE *.md

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/redoflacs \
      --prefix PATH : ${stdenv.lib.makeBinPath [ flac sox ]}
  '';

  meta = with stdenv.lib; {
    description = "Parallel BASH commandline FLAC compressor, verifier, organizer, analyzer, and retagger";
    homepage    = src.meta.homepage;
    license     = licenses.gpl2;
    platforms   = platforms.all;
  };
}
