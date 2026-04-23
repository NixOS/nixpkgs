{
  lib,
  stdenv,
  buildNpmPackage,
  buildDotnetModule,
  fetchFromGitHub,
  autoPatchelfHook,
  dotnetCorePackages,
  bun,
  icu,
  openssl,
  krb5,
}:

let
  # for update.sh easy to handle
  ngclientVersion = "0.0.207";
  ngclientRev = "42d711a541ca1ee2ff43f95cce89e8eeb224afc8";
  ngclientHash = "sha256-VS6kb/2YGn/TBDXt62UifD7BHCWE2xiUkLcGBXzV+ww=";

  # from Duplicati/Server/webroot/ngclient/package.json
  ngclient = buildNpmPackage {
    pname = "ngclient";
    version = ngclientVersion;

    src = fetchFromGitHub {
      owner = "duplicati";
      repo = "ngclient";
      rev = ngclientRev;
      hash = ngclientHash;
    };

    npmDepsHash = "sha256-wkzSUEqoB013yNbC1sX4qRz8DuGWRB20/M+ue/thbOQ=";

    nativeBuildInputs = [ bun ];

    npmBuildScript = "build:prod";

    env = {
      NG_CLI_ANALYTICS = "false";
      CI = "true";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/ngclient/* $out/

      runHook postInstall
    '';

    postInstall = ''
      substituteInPlace $out/browser/index.html \
          --replace-fail '<base href="/">' '<base href="/ngclient/">'
    '';
  };
in
buildDotnetModule rec {
  pname = "duplicati";
  version = "2.3.0.0";
  channel = "stable";
  buildDate = "2026-04-14";

  src = fetchFromGitHub {
    owner = "duplicati";
    repo = "duplicati";
    tag = "v${version}_${channel}_${buildDate}";
    hash = "sha256-X9SaH83p2RJWeJK8MfNwPgI2c3AfBHhbxOaFz4c26qU=";
    stripRoot = true;
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

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

  postPatch = ''
    sed -i '/Duplicati.ShellExtension.csproj/d' Duplicati.slnx

    rm -rf Duplicati/Server/webroot/ngclient
    ln -s ${ngclient}/browser Duplicati/Server/webroot/ngclient
  '';

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

  meta = {
    description = "Free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
    homepage = "https://www.duplicati.com/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      nyanloutre
      bot-wxt1221
      puiyq
    ];
    # platforms inherited from dotnet-sdk.
  };
}
