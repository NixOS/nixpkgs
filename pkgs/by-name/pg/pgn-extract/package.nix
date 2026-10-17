{
  lib,
  stdenv,
  fetchzip,
  installShellFiles,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgn-extract";
  version = "25-01";

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  src = fetchzip {
    url = "https://www.cs.kent.ac.uk/~djb/pgn-extract/pgn-extract-${finalAttrs.version}.tgz";
    hash = "sha256-SHteE0wpuS2JxrS9KvkIxe4krGzRnQVBD4dQgabFLlU=";
    stripRoot = false;
  };

  sourceRoot = "source/pgn-extract";

  postPatch = ''
    # Avoid impurity: upstream Makefile hardcodes /usr/local include directory
    substituteInPlace Makefile --replace-fail \
    "-I/usr/local/lib/ansi-include" ""

    substituteInPlace pgn-extract.man --replace-fail \
    "/usr/share/doc/pgn-extract/help.html" \
    "$out/share/doc/pgn-extract/help.html"
  '';

  # Makefile hardcodes CC=gcc which fails on Darwin (uses clang)
  # Override to use stdenv's compiler (gcc on Linux, clang on Darwin)
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin pgn-extract
    install -Dm444 -t $out/share eco.pgn
    install -Dm444 -t $out/share/doc/pgn-extract help.html style.css
    installManPage --name pgn-extract.1 pgn-extract.man

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    make --directory=test PGN_EXTRACT=../pgn-extract ECO_FILE=../eco.pgn

    runHook postCheck
  '';

  postFixup = ''
    wrapProgram $out/bin/pgn-extract \
      --set-default ECO_FILE $out/share/eco.pgn
  '';

  meta = {
    mainProgram = "pgn-extract";
    description = "Portable Game Notation (PGN) Manipulator for Chess Games";
    homepage = "https://www.cs.kent.ac.uk/~djb/pgn-extract/";
    changelog = "https://www.cs.kent.ac.uk/~djb/pgn-extract/changes.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.platforms.unix;
  };
})
