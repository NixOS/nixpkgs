{
  fetchFromGitHub,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "smithy";
  version = "1.63.0";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

      arch = selectSystem {
        aarch64-darwin = "darwin-aarch64";
        aarch64-linux = "linux-aarch64";
        x86_64-darwin = "darwin-x86_64";
        x86_64-linux = "linux-x86_64";
      };
    in
    fetchurl {
      url = "https://github.com/smithy-lang/smithy/releases/download/${finalAttrs.version}/smithy-cli-${arch}.zip";
      hash = selectSystem {
        aarch64-darwin = "sha256-a7RMXclZOAHHQUmvNk3qKcIdPJYgxINIH2ZFsiIKUEc=";
        aarch64-linux = "sha256-Ijj6Ak+tMQBTZDzHTJB0Tawdh3Pfrq0cvXuB05g4X1Q=";
        x86_64-darwin = "sha256-UJRnzJDp045tAgzFZlOMcTQoIPrYMD5DBIuCNKOVnHU=";
        x86_64-linux = "sha256-pH3H5qFadIGHRAKvEMj6WsfMf+yd3hTpwyafKRBtDKg=";
      };
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
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
