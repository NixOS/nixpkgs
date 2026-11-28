{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
  runCommandLocal,
  asciidoctor-with-extensions,
  withJava ? true,
  jre, # Used by asciidoctor-diagram for ditaa and PlantUML
}:

let
  exes = [
    "asciidoctor"
    "asciidoctor-epub3"
    "asciidoctor-multipage"
    "asciidoctor-pdf"
    "asciidoctor-reducer"
    "asciidoctor-revealjs"
  ];
in
bundlerApp {
  pname = "asciidoctor";
  gemdir = ./.;
  inherit exes;

  nativeBuildInputs = [ makeWrapper ];
  postBuild = lib.optionalString withJava (
    lib.concatMapStrings (exe: ''
      wrapProgram $out/bin/${exe} --set JAVA_HOME ${jre.home}
    '') exes
  );

  passthru = {
    updateScript = bundlerUpdateScript "asciidoctor-with-extensions";
    tests.generate-diagram =
      runCommandLocal "asciidoctor-diagram" { nativeBuildInputs = [ asciidoctor-with-extensions ]; }
        ''
          asciidoctor -r asciidoctor-diagram --destination-dir "$out" ${./test.adoc}
          [ -f "$out/ditaa.png" ]
        '';
  };

  meta = {
    description = "Faster Asciidoc processor written in Ruby, with many extensions enabled";
    homepage = "https://asciidoctor.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.unix;
  };
}
