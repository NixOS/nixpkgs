{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, installShellFiles
, flac
, sox
, withAucdtect ? false
, aucdtect ? null
}:

stdenv.mkDerivation rec {
  pname = "redoflacs";
  version = "0.30.20190903";

  src = fetchFromGitHub {
    owner = "sirjaren";
    repo = "redoflacs";
    rev = "4ca544cbc075d0865884906208cb2b8bc318cf9e";
    sha256 = "19lcl09d4ngz2zzwd8dnnxx41ddvznhar6ggrlf1xvkr5gd7lafp";
  };

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin redoflacs
    install -Dm644 -t $out/share/doc/redoflacs LICENSE *.md
    installManPage redoflacs.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/redoflacs \
      --prefix PATH : ${stdenv.lib.makeBinPath ([ flac sox ] ++ lib.optional withAucdtect aucdtect)}
  '';

  meta = with lib; {
    description = "Parallel BASH commandline FLAC compressor, verifier, organizer, analyzer, and retagger";
    homepage = src.meta.homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
