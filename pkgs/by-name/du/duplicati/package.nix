{
  lib,
  stdenv,
  buildNpmPackage,
  buildDotnetModule,
  fetchFromGitHub,
  autoPatchelfHook,
  dotnetCorePackages,
  npm-lockfile-fix,
  icu,
  openssl,
  krb5,
}:

let
  version = "2.4.0.1";
  channel = "stable";
  buildDate = "2026-10-07";
  ngclientVersion = "0.0.238";
  ngclientRev = "374ce0d56d519caa88999989e10dc16ef39c4536";
  ngclientHash = "sha256-4EGtVo79p7P+L21vnVhl1ameFe1RL+7nsEmickONrYw=";

  # from Duplicati/Server/webroot/ngclient/package.json
  ngclient = buildNpmPackage {
    pname = "ngclient";
    version = ngclientVersion;
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "duplicati";
      repo = "ngclient";
      rev = ngclientRev;
      hash = ngclientHash;

      postFetch = ''
        ${lib.getExe npm-lockfile-fix} -r $out/package-lock.json
      '';
    };

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail '"build:prod": "bun run gen:font & ng build' \
                       '"build:prod": "npm run gen:font && ng build' \
        --replace-fail '"gen:font": "ship-fg' \
                       '"gen:font": "node node_modules/.bin/ship-fg'
    '';

    npmDepsHash = "sha256-jDHpuGm7juGjlRQ4Sq85lW6lcSwYSczryYxdL8uE9gg=";

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
buildDotnetModule {
  pname = "duplicati";
  inherit version channel buildDate;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duplicati";
    repo = "duplicati";
    tag = "v${version}_${channel}_${buildDate}";
    hash = "sha256-f/NOjUiePDt1kDxEEH0NSKlgIKuZmoFax2+wgjN5Sdk=";
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

  autoPatchelfIgnoreMissingDeps =
    lib.optionals (!stdenv.hostPlatform.isMusl) [
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
      "libc.musl-armv7.so.1"
    ]
    ++ [
      "liblog.so"
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
    for mapping in \
      "Duplicati.Agent:duplicati-agent" \
      "Duplicati.GUI.TrayIcon:duplicati" \
      "Duplicati.Server:duplicati-server" \
      "Duplicati.Service:duplicati-service" \
      "Duplicati.CommandLine:duplicati-cli" \
      "Duplicati.CommandLine.SyncTool:duplicati-sync-tool" \
      "Duplicati.CommandLine.SourceTool:duplicati-source-tool" \
      "Duplicati.CommandLine.DatabaseTool:duplicati-database-tool" \
      "Duplicati.CommandLine.SharpAESCrypt:duplicati-aescrypt" \
      "Duplicati.CommandLine.AutoUpdater:duplicati-autoupdater" \
      "Duplicati.CommandLine.BackendTester:duplicati-backend-tester" \
      "Duplicati.CommandLine.BackendTool:duplicati-backend-tool" \
      "Duplicati.CommandLine.RecoveryTool:duplicati-recovery-tool" \
      "Duplicati.CommandLine.SecretTool:duplicati-secret-tool" \
      "Duplicati.CommandLine.ServerUtil:duplicati-server-util" \
      "Duplicati.CommandLine.Snapshots:duplicati-snapshots"
    do
      IFS=: read -r source target <<< "$mapping"
      mv "$out/bin/$source" "$out/bin/$target"
    done

    cp "$out/bin/duplicati-server" "$out/lib/duplicati/duplicati-server"
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
