{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
  plantuml-c4,
  plantuml,
  runCommand,
}:

# The C4-PlantUML docs say that it suffices to run plantuml with the
# -DRELATIVE_INCLUDE="..." arg to make plantuml find the C4 templates
# when included like "!include C4_Container.puml".
# Unfortunately, this is not sufficient in practise, when the path is not ".".
# What helps is setting -Dplantuml.include.path="..." *before* the jar
# parameter.
# The -DRELATIVE_INCLUDE param then *still* needs to be set (*after* the jar
# argument), because the C4 template vars check for existence of this variable
# and if it is not set, reference paths in the internet.

let
  c4-lib = fetchzip {
    url = "https://github.com/plantuml-stdlib/C4-PlantUML/archive/refs/tags/v2.10.0.zip";
    hash = "sha256-p9Njb7VauXVf6yOBDQrO9mS+za9NntFUCK5tig0mH3U=";
  };

  sprites = fetchzip {
    url = "https://github.com/tupadr3/plantuml-icon-font-sprites/archive/refs/tags/v3.0.0.zip";
    hash = "sha256-I/cR1VPR7aKyTZF9X/4GkgcxV9+sLgNpTZugvCy0Dvs=";
  };

  # In order to pre-fix the plantuml.jar parameter with the argument
  # -Dplantuml.include.path=..., we post-fix the java command using a wrapper.
  # This way the plantuml derivation can remain unchanged.
  plantumlWithExtraPath =
    let
      plantumlIncludePath = lib.concatStringsSep ":" [
        c4-lib
        sprites
      ];
      includeFlag = "-Dplantuml.include.path=${lib.escapeShellArg plantumlIncludePath}";
      postFixedJre = runCommand "jre-postfixed" { nativeBuildInputs = [ makeWrapper ]; } ''
        mkdir -p $out/bin

        makeWrapper ${jre}/bin/java $out/bin/java \
          --add-flags ${lib.escapeShellArg includeFlag}
      '';
    in
    plantuml.override { jre = postFixedJre; };
in

stdenv.mkDerivation {
  pname = "plantuml-c4";
  version = "2.10.0";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin

    makeWrapper ${plantumlWithExtraPath}/bin/plantuml $out/bin/plantuml \
      --add-flags "-DRELATIVE_INCLUDE=\"${c4-lib}\""

    $out/bin/plantuml -help
  '';

  passthru.tests.example-c4-diagram =
    runCommand "c4-plantuml-sample.png" { nativeBuildInputs = [ plantuml-c4 ]; }
      ''
        sed 's/https:.*\///' "${c4-lib}/samples/C4_Context Diagram Sample - enterprise.puml" > sample.puml
        plantuml sample.puml -o $out

        sed 's/!include ..\//!include /' ${sprites}/examples/complex-example.puml > sprites.puml
        plantuml sprites.puml -o $out
      '';

  meta = with lib; {
    description = "PlantUML bundled with C4-Plantuml and plantuml sprites library";
    mainProgram = "plantuml";
    homepage = "https://github.com/plantuml-stdlib/C4-PlantUML";
    license = licenses.mit;
    maintainers = with maintainers; [
      tfc
      anthonyroussel
    ];
    platforms = platforms.unix;
  };
}
