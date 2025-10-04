{
  fetchurl,
  jre,
  lib,
  makeBinaryWrapper,
  stdenv,
  testers,
  unzip,
}:

let
  platformMap = {
    "x86_64-linux" = {
      arch = "linux-x86_64";
      hash = "sha256-y2Ryl/HbVsq0V1HNyqTWpehfqrJ2jNmfk2np8izAClo=";
    };
    "aarch64-linux" = {
      arch = "linux-aarch64";
      hash = "sha256-7zkIYKvnLKIaGqybJYMw5cTtHkN06VuifttsxK2R54c=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x86_64";
      hash = "sha256-6087IQSVCJ6AG+y797hlTySwdTgOSyrJbX9GZYKdP14=";
    };
    "aarch64-darwin" = {
      arch = "darwin-aarch64";
      hash = "sha256-w7Jc3zKi+jXRmi9CQEg1RQ+QBpzRDniY2UtaawT2Ai0=";
    };
  };

  platform =
    platformMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "smithy";
  version = "1.62.0";

  src = fetchurl {
    url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-${platform.arch}.zip";
    hash = platform.hash;
  };

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  buildInputs = [ jre ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "smithy --version";
    version = finalAttrs.version;
  };

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin/ lib/ conf/ $out/

    # Replace bundled Java binaries with symlinks to Nix-provided JRE
    ln -sf ${jre}/bin/java $out/bin/java
    ln -sf ${jre}/bin/keytool $out/bin/keytool

    if [ -f $out/bin/smithy ]; then
      wrapProgram $out/bin/smithy \
        --set JAVA_HOME "${jre}" \
        --set JAVACMD "${jre}/bin/java" \
        --set DEFAULT_JVM_OPTS ""
    else
      echo "Could not find smithy binary at bin/smithy"
      exit 1
    fi

    runHook postInstall
  '';

  meta = {
    description = "CLI for Smithy, a language for defining services and SDKs";
    mainProgram = "smithy";
    longDescription = ''
      Smithy is a language for defining services and SDKs. The Smithy CLI
      provides commands to build, validate, and generate code from Smithy models.
    '';
    homepage = "https://smithy.io/";
    changelog = "https://github.com/smithy-lang/smithy/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ szympajka ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
