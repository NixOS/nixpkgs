{
  lib,
  stdenv,
<<<<<<< HEAD
  buildDotnetModule,
  fetchFromGitHub,
  autoPatchelfHook,
  dotnetCorePackages,
  icu,
  openssl,
  krb5,
}:

buildDotnetModule rec {
  pname = "duplicati";
  version = "2.2.0.1";
  channel = "stable";
  buildDate = "2025-11-09";

  src = fetchFromGitHub {
    owner = "duplicati";
    repo = "duplicati";
    tag = "v${version}_${channel}_${buildDate}";
    hash = "sha256-fARK2nAqE9aN2PQSC62yIcYr3e/kBT3BVTBxLwMqk24=";
    stripRoot = true;
  };

  patches = [ ./fix-unit-tests.patch ];

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  enableParallelBuilding = false;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    icu
    openssl
    krb5
  ];

  autoPatchelfIgnoreMissingDeps = lib.optionals (!stdenv.hostPlatform.isMusl) [
    "libc.musl-x86_64.so.1"
    "libc.musl-aarch64.so.1"
    "libc.musl-armv7.so.1"
  ];

  executables = [
    "Duplicati.Agent"
    "Duplicati.CommandLine"
    "Duplicati.CommandLine.AutoUpdater"
    "Duplicati.CommandLine.BackendTester"
    "Duplicati.CommandLine.BackendTool"
    "Duplicati.CommandLine.DatabaseTool"
    "Duplicati.CommandLine.RecoveryTool"
    "Duplicati.CommandLine.SecretTool"
    "Duplicati.CommandLine.ServerUtil"
    "Duplicati.CommandLine.SharpAESCrypt"
    "Duplicati.CommandLine.Snapshots"
    "Duplicati.CommandLine.SourceTool"
    "Duplicati.CommandLine.SyncTool"
    "Duplicati.GUI.TrayIcon"
    "Duplicati.Server"
    "Duplicati.Service"
  ];

  postFixup = ''
    mv $out/bin/Duplicati.Agent $out/bin/duplicati-agent
    mv $out/bin/Duplicati.GUI.TrayIcon $out/bin/duplicati
    mv $out/bin/Duplicati.Server $out/bin/duplicati-server
    cp $out/bin/duplicati-server $out/lib/duplicati/duplicati-server
    mv $out/bin/Duplicati.Service $out/bin/duplicati-service
    mv $out/bin/Duplicati.CommandLine $out/bin/duplicati-cli
    mv $out/bin/Duplicati.CommandLine.SyncTool $out/bin/duplicati-sync-tool
    mv $out/bin/Duplicati.CommandLine.SourceTool $out/bin/duplicati-source-tool
    mv $out/bin/Duplicati.CommandLine.DatabaseTool $out/bin/duplicati-database-tool
    mv $out/bin/Duplicati.CommandLine.SharpAESCrypt $out/bin/duplicati-aescrypt
    mv $out/bin/Duplicati.CommandLine.AutoUpdater $out/bin/duplicati-autoupdater
    mv $out/bin/Duplicati.CommandLine.BackendTester $out/bin/duplicati-backend-tester
    mv $out/bin/Duplicati.CommandLine.BackendTool $out/bin/duplicati-backend-tool
    mv $out/bin/Duplicati.CommandLine.RecoveryTool $out/bin/duplicati-recovery-tool
    mv $out/bin/Duplicati.CommandLine.SecretTool $out/bin/duplicati-secret-tool
    mv $out/bin/Duplicati.CommandLine.ServerUtil $out/bin/duplicati-server-util
    mv $out/bin/Duplicati.CommandLine.Snapshots $out/bin/duplicati-snapshots
  '';

  passthru.updateScript = ./update.sh;

=======
  fetchzip,
  autoPatchelfHook,
  gcc-unwrapped,
  zlib,
  lttng-ust_2_12,
  icu,
  openssl,
  makeBinaryWrapper,
}:

let
  _supportedPlatforms = {
    "armv7l-linux" = "linux-arm7";
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
  };
  _platform = _supportedPlatforms."${stdenv.hostPlatform.system}";
  # nix --extra-experimental-features nix-command hash convert --to sri "sha256:`nix-prefetch-url --unpack https://updates.duplicati.com/stable/duplicati-2.1.0.5_stable_2025-03-04-linux-arm64-cli.zip`"
  _fileHashForSystem = {
    "armv7l-linux" = "sha256-FQQ07M0rwvxNkHPW6iK5WBTKgFrZ4LOP4vgINfmtq4k=";
    "x86_64-linux" = "sha256-1QspF/A3hOtqd8bVbSqClJIHUN9gBrd18J5qvZJLkQE=";
    "aarch64-linux" = "sha256-mSNInaCkNf1MBZK2M42SjJnYRtB5SyGMvSGSn5oH1Cs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  # TODO build duplicati from source https://github.com/duplicati/duplicati/blob/master/.github/workflows/build-packages.yml
  pname = "duplicati";
  version = "2.1.0.5";
  channel = "stable";
  buildDate = "2025-03-04";

  src = fetchzip {
    url =
      with finalAttrs;
      "https://updates.duplicati.com/stable/duplicati-${version}_${channel}_${buildDate}-${_platform}-cli.zip";
    hash = _fileHashForSystem."${stdenv.hostPlatform.system}";
    stripRoot = true;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];
  buildInputs = [
    gcc-unwrapped
    zlib
    lttng-ust_2_12
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r * "$out/share/"
    for file in $out/share/duplicati-*; do
      makeBinaryWrapper "$file" "$out/bin/$(basename $file)" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          openssl
        ]
      }
    done

    runHook postInstall
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
    homepage = "https://www.duplicati.com/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      nyanloutre
      bot-wxt1221
<<<<<<< HEAD
      puiyq
    ];
    # platforms inherited from dotnet-sdk.
  };
}
=======
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = builtins.attrNames _supportedPlatforms;
  };
})
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
