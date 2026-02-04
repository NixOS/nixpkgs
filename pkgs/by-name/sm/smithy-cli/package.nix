{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk17,
}:

let
  version = "1.67.0";

  sources = {
    x86_64-linux = {
      platform = "linux-x86_64";
      hash = "sha256-/qCxXC4uUfg10R5MeR7DrvUvAeTPJRt8z47SsAjN424=";
    };
    aarch64-linux = {
      platform = "linux-aarch64";
      hash = "sha256-8nat7tp9extvAU0VWIKQ88SGJC/lbt0G0NlIveteh1o=";
    };
    x86_64-darwin = {
      platform = "darwin-x86_64";
      hash = "sha256-K6v0o7xkRevwz47Y0PhQhFemzXvOp7Y0ggMRY9kS+iw=";
    };
    aarch64-darwin = {
      platform = "darwin-aarch64";
      hash = "sha256-XPFkVPpQjt2f6ifZxGbSTtmAltWpWdqPWlEkijvLio4=";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "smithy-cli";
  inherit version;

  src = fetchzip {
    url = "https://github.com/smithy-lang/smithy/releases/download/${version}/smithy-cli-${source.platform}.zip";
    hash = source.hash;
  };

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

  meta = {
    description = "CLI for the Smithy interface definition language (IDL)";
    homepage = "https://smithy.io/";
    changelog = "https://github.com/smithy-lang/smithy/releases/tag/${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    mainProgram = "smithy";
    maintainers = [ lib.maintainers.joshgodsiff ];
    platforms = lib.attrNames sources;
  };
}
