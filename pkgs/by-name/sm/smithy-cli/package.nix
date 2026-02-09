{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk17,
  testers,
  runCommand,
  writeText,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "smithy-cli";
  version = "1.67.0";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    # Copy the launcher script
    cp bin/smithy $out/bin/smithy
    chmod +x $out/bin/smithy

    # Copy lib directory (contains JARs and bundled JRE)
    cp -r lib/* $out/lib/

    # Replace the bundled java with system java
    ln -sf ${jdk17}/bin/java $out/bin/java

    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchzip {
        url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-linux-x86_64.zip";
        hash = "sha256-/qCxXC4uUfg10R5MeR7DrvUvAeTPJRt8z47SsAjN424=";
      };
      "aarch64-linux" = fetchzip {
        url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-linux-aarch64.zip";
        hash = "sha256-8nat7tp9extvAU0VWIKQ88SGJC/lbt0G0NlIveteh1o=";
      };
      "x86_64-darwin" = fetchzip {
        url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-darwin-x86_64.zip";
        hash = "sha256-K6v0o7xkRevwz47Y0PhQhFemzXvOp7Y0ggMRY9kS+iw=";
      };
      "aarch64-darwin" = fetchzip {
        url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-darwin-aarch64.zip";
        hash = "sha256-XPFkVPpQjt2f6ifZxGbSTtmAltWpWdqPWlEkijvLio4=";
      };
    };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      validate = runCommand "smithy-cli-validate-test" { } ''
        ${lib.getExe finalAttrs.finalPackage} validate ${writeText "example.smithy" ''
          $version: "2.0"

          namespace example

          service ExampleService {
              version: "2023-01-01"
              operations: [GetUser]
          }

          operation GetUser {
              input: GetUserInput
              output: GetUserOutput
          }

          structure GetUserInput {
              @required
              userId: String
          }

          structure GetUserOutput {
              @required
              name: String
          }
        ''}
        touch $out
      '';
    };
  };

  meta = {
    description = "CLI for the Smithy interface definition language (IDL)";
    homepage = "https://smithy.io/";
    changelog = "https://github.com/smithy-lang/smithy/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    mainProgram = "smithy";
    maintainers = [ lib.maintainers.joshgodsiff ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
