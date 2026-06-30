{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "sonarqube-cli";
  version = "1.2.0.3278";

  src =
    let
      baseUrl = "https://binaries.sonarsource.com/Distribution/sonarqube-cli/${finalAttrs.version}";
    in
    {
      x86_64-linux = fetchurl {
        url = "${baseUrl}/linux/sonarqube-cli-${finalAttrs.version}-linux-x86-64.bin";
        hash = "sha256-UIdR1ldHKTV7pBWjZxVxMLH7T15ZWdbL0WFw042l+Vc=";
      };
      aarch64-linux = fetchurl {
        url = "${baseUrl}/linux/sonarqube-cli-${finalAttrs.version}-linux-arm64.bin";
        hash = "sha256-w0NbqtRMJ5UGF6plslKCTsATBxP1RAc8SxwnFbi3CFE=";
      };
      aarch64-darwin = fetchurl {
        url = "${baseUrl}/macos/sonarqube-cli-${finalAttrs.version}-macos-arm64.bin";
        hash = "sha256-ehrq6hMONdZXDj9MjzLenvyb2hhwEIuhGJQCt7p/Ju0=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # The distributed binary is a Bun standalone executable: the application is
  # appended to the runtime as trailing data that Bun locates from the end of
  # the file. Stripping rewrites the ELF and discards that payload, leaving the
  # bare Bun runtime, so stripping must be disabled.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/sonar
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    $out/bin/sonar --help 2>&1 | grep -qF "SonarQube CLI"
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line companion for SonarQube Cloud and SonarQube Server";
    longDescription = ''
      The SonarQube CLI (sonar) is a command-line companion for SonarQube Cloud
      and SonarQube Server. It lets you scan for secrets, analyze local changes,
      query projects and issues, and wire SonarQube into AI coding assistants,
      all from your terminal.
    '';
    homepage = "https://www.sonarsource.com/sonarqube/cli";
    # The public source is LGPL-3.0-or-later, but the distributed binary bundles
    # proprietary commercial components (sonar-secrets, sca-scanner-cli), so the
    # artifact as a whole is unfree.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      kmjayadeep
      jayadeep-km-sonarsource
    ];
    mainProgram = "sonar";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
