{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gema";
  version = "2.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/gema/files/gema/gema-${finalAttrs.version}/gema-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-c7qxgZYk/QaqocjRXVlgJxUWCgf3T1JBY7v9Fg9YfIU=";
  };

  makeFlags = [ "--directory=src" ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 src/gema -t $out/bin
    installManPage doc/gema.1
    runHook postInstall
  '';

  meta = {
    description = "General purpose text processing utility based on the concept of pattern matching";
    longDescription = "Reads an input file and copies it to an output file transforming the data as specified by the patterns defined by the user.";
    homepage = "https://gema.sourceforge.net/";
    license = lib.licenses.mit;
    mainProgram = "gema";
    maintainers = with lib.maintainers; [ quag ];
    platforms = lib.platforms.unix;
  };
})
