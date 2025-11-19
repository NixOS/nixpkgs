{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  installShellFiles,
  buildPackages,
  withShellCompletions ? stdenv.hostPlatform.emulatorAvailable buildPackages,
  # tests
  testers,
}:
let
  version = "0.12.64";

  sources = {
    x86_64-linux = {
      url = "https://storage.eu-north1.nebius.cloud/cli/release/${version}/linux/x86_64/nebius";
      hash = "sha256-vqubl8lmRgSecLYUJyGyJuu3i61N5OJyIVUSt2G0STk=";
    };
    aarch64-linux = {
      url = "https://storage.eu-north1.nebius.cloud/cli/release/${version}/linux/arm64/nebius";
      hash = "sha256-A3w+mt5nwkIENv0ScwwVq+n0YJoMxhuQWWdcIvAfcQ8=";
    };
    aarch64-darwin = {
      url = "https://storage.eu-north1.nebius.cloud/cli/release/${version}/darwin/arm64/nebius";
      hash = "sha256-Wtc964BjFk2rQ5CNDIGbQpvHouZzXQ7KzlbdG2ovX1k=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = "nebius";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  emulator = lib.optionalString (
    withShellCompletions && !stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) (stdenv.hostPlatform.emulator buildPackages);

  installPhase =
    ''
      runHook preInstall
      mkdir -p -- "$out/bin"
      cp -- "$src" "$out/bin/nebius"
      chmod +x -- "$out/bin/nebius"
    ''
    + lib.optionalString withShellCompletions ''
      for shell in bash zsh; do
        ''${emulator:+"$emulator"} "$out/bin/nebius" completion $shell >nebius.$shell
        installShellCompletion nebius.$shell
      done
    ''
    + ''
      runHook postInstall
    '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "nebius version";
    };
  };

  meta = {
    description = "Command line interface for Nebius cloud platform";
    homepage = "https://nebius.com/";
    changelog = "https://docs.nebius.com/cli/release-notes";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jennifgcrl ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "nebius";
  };
})
