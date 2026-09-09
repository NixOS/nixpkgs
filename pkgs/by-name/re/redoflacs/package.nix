{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  flac,
  sox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redoflacs";
  version = "0.30.20190903";

  src = fetchFromGitHub {
    owner = "sirjaren";
    repo = "redoflacs";
    rev = "4ca544cbc075d0865884906208cb2b8bc318cf9e";
    sha256 = "19lcl09d4ngz2zzwd8dnnxx41ddvznhar6ggrlf1xvkr5gd7lafp";
  };

  dontBuild = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin redoflacs
    install -Dm644 -t $out/share/doc/redoflacs LICENSE *.md
    installManPage redoflacs.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/redoflacs \
      --prefix PATH : ${
        lib.makeBinPath [
          flac
          sox
        ]
      }
  '';

  meta = {
    description = "Parallel BASH commandline FLAC compressor, verifier, organizer, analyzer, and retagger";
    mainProgram = "redoflacs";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
  };
})
