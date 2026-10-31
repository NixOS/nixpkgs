{
  lib,
  stdenv,
  perl,
  writeTextFile,
  isabelle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash_process";
  inherit (isabelle) src version;

  nativeBuildInputs = [
    perl
  ];

  buildPhase = ''
    runHook preBuild

    # Source code is hidden in a scala file, and unpacked when built with
    # `isabelle component_bash_process`
    # However, this requires the bash_process to already be built...
    ${perl}/bin/perl -e 'local $/ = undef; while (<>) { if (/"""(.*?)"""/s) { print "$1"; } }' \
      "src/Pure/Admin/component_bash_process.scala" > bash_process.c
    cc -Wall bash_process.c -o bash_process

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bash_process $out/bin/bash_process

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "bash_process-settings";
    text = ''
      ISABELLE_BASH_PROCESS_HOME="${finalAttrs.finalPackage}"
      ISABELLE_BASH_PROCESS="$ISABELLE_BASH_PROCESS_HOME/bin/bash_process"
    '';
    destination = "/etc/settings";
  };

  meta = {
    description = "Bash process with separate process group id";
    homepage = "https://isabelle.in.tum.de/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.unix;
  };
})
