{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "sonarqube-cli";
  version = "1.5.0.4158";

  src =
    let
      baseUrl = "https://binaries.sonarsource.com/Distribution/sonarqube-cli/${finalAttrs.version}";
    in
    {
      x86_64-linux = fetchurl {
        url = "${baseUrl}/linux/sonarqube-cli-${finalAttrs.version}-linux-x86-64.bin";
        hash = "sha256-29TuICV/cwEK1/iiwlUjcwOe42EK8lJBbm8T9/+RVGA=";
      };
      aarch64-linux = fetchurl {
        url = "${baseUrl}/linux/sonarqube-cli-${finalAttrs.version}-linux-arm64.bin";
        hash = "sha256-WWAY7AP2KCWI5r3laQRiWkq9DGXD5Nw+Bans0oOBxkQ=";
      };
      aarch64-darwin = fetchurl {
        url = "${baseUrl}/macos/sonarqube-cli-${finalAttrs.version}-macos-arm64.bin";
        hash = "sha256-GB32aiW2yrakQo94L+J54BN0CIwfMkD9lG97kdNUV+Y=";
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
