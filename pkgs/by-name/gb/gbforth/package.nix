{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gforth,
  writableTmpDirAsHomeHook,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gbforth";
  version = "unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "ams-hackers";
    repo = "gbforth";
    rev = "39ec80520bf7bedf881eca01909cc9eeb7334a60";
    hash = "sha256-3Zky+ZKA0FPhO1l5pFdmDQgdwvvO3QgPGsgVracY5xw=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gbforth $out/bin
    cp -r lib shared src gbforth.fs $out/share/gbforth/
    makeWrapper ${gforth}/bin/gforth $out/bin/gbforth \
      --set GBFORTH_PATH $out/share/gbforth/lib \
      --add-flags $out/share/gbforth/gbforth.fs
    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/gbforth examples/simon/simon.fs
    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://gbforth.org/";
    description = "Forth-based Game Boy development kit";
    mainProgram = "gbforth";
    longDescription = ''
      A Forth-based Game Boy development kit.
      It features a Forth-based assembler, a cross-compiler with support for
      lazy code generation and a library of useful words.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
