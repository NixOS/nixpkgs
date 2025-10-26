{
  fetchurl,
  jre,
  lib,
  makeBinaryWrapper,
  stdenv,
  unzip,
  versionCheckHook,
  writeScript,
  coreutils,
  gnused,
  bash,
}:
let
  hashes = {
    aarch64-darwin = {
      arch = "darwin-aarch64";
      hash = "sha256-6Da7Ro6xF/BVl/omOGRoFyiVDjLBCoVZLrTdZDz97og=";
    };
    aarch64-linux = {
      arch = "linux-aarch64";
      hash = "sha256-K77WF3sMT8L3XEJmpc9yVxyjXOZtqIAKkNTPA8a7LUI=";
    };
    x86_64-darwin = {
      arch = "darwin-x86_64";
      hash = "sha256-VbXjl/1C/qQHMm5RLa+bzTiBnANTThJD5KD8cansXe0=";
    };
    x86_64-linux = {
      arch = "linux-x86_64";
      hash = "sha256-7m5tJEFrU2JLp/MjYossqKpno0n747LpLpgXLD89akU=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smithy";
  version = "1.68.0";

  src =
    let
      srcInfo =
        hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-${srcInfo.arch}.zip";
      hash = srcInfo.hash;
    };

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  buildInputs = [
    jre
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    bash
    coreutils
    gnused
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin/ lib/ conf/ $out/

    # Replace bundled Java binaries with symlinks to Nix-provided JRE
    ln -sf ${jre}/bin/java $out/bin/java
    ln -sf ${jre}/bin/keytool $out/bin/keytool

    wrapProgram $out/bin/smithy \
      --set JAVA_HOME "${jre}" \
      --set JAVACMD "${jre}/bin/java" \
      --set DEFAULT_JVM_OPTS "" \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix PATH : "${
          lib.makeBinPath [
            bash
            coreutils
            gnused
          ]
        }"
      ''}

    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update-smithy" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix curl jq nix-update common-updater-scripts
      set -eou pipefail
      version=$(nix eval --raw --file . smithy.version)
      nix-update smithy
      latestVersion=$(nix eval --raw --file . smithy.version)
      if [[ "$latestVersion" == "$version" ]]; then
        exit 0
      fi
      systems=$(nix eval --json -f . smithy.meta.platforms | jq --raw-output '.[]')
      for system in $systems; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . smithy.src.url --system "$system")))
        update-source-version smithy $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
      done
    '';
  };

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
    platforms = lib.attrNames hashes;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
