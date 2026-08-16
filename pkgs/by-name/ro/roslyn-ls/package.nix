{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenvNoCC,
  testers,
  jq,
  runCommand,
  expect,
}:
let
  pname = "roslyn-ls";
  # see https://github.com/dotnet/roslyn/blob/main/eng/targets/TargetFrameworks.props
  dotnet-sdk =
    with dotnetCorePackages;
    # required sdk
    sdk_10_0
    // {
      # with additional packages to minimize deps.json
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };
  # should match the default NetVSCode property
  # see https://github.com/dotnet/roslyn/blob/main/eng/targets/TargetFrameworks.props
  dotnet-runtime = dotnetCorePackages.sdk_10_0.runtime;

  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;

  project = "Microsoft.CodeAnalysis.LanguageServer";
in
buildDotnetModule (finalAttrs: {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.148.23-prerelease";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${finalAttrs.vsVersion}";
    hash = "sha256-d3RqQihalcCxTbCJZXZUf2ABZ483UhBWFzpiXwCcAuA=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "5.11.0-1.26380.4";
  projectFile = "src/LanguageServer/${project}/${project}.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.json;

  nativeBuildInputs = [ jq ];

  patches = [
    # until made configurable/and or different location
    # https://github.com/dotnet/roslyn/issues/76892
    ./cachedirectory.patch
  ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json
  '';

  # don't build binary
  useAppHost = false;
  dotnetFlags = [
    "-p:TargetRid=${rid}"
    # we don't want to build the binary
    # and useAppHost is not enough, need to explicitly set to false
    "-p:UseAppHost=false"
    # avoid platform-specific crossgen packages
    "-p:PublishReadyToRun=false"
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
    # avoid unnecessary packages in deps.json
    "-p:EnableAppHostPackDownload=false"
    "-p:EnableRuntimePackDownload=false"
  ];

  executables = [ project ];

  postInstall = ''
    # fake executable that we substitute in postFixup
    touch $out/lib/$pname/${project}
    chmod +x $out/lib/$pname/${project}
  '';

  # problem and solution:
  # BuildHost project within roslyn is running Build target during publish -> --no-build removed
  installPhase = ''
    runHook preInstall

    env dotnet publish $dotnetProjectFiles \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        -p:InformationalVersion=$version \
        -p:PublishTrimmed=false \
        -p:OverwriteReadOnlyFiles=true \
        --configuration Release \
        --no-self-contained \
        --output "$out/lib/$pname" \
        --no-restore \
        --runtime ${rid} \
        ''${dotnetInstallFlags[@]}  \
        ''${dotnetFlags[@]}

    runHook postInstall
  '';

  # force dotnet-runtime to run the dll
  # but keep the wrapper created with useDotnetFromEnv to allow LS to work properly on codebases
  postFixup = ''
    rm -f $out/lib/$pname/${project}
    substituteInPlace $out/bin/${project} \
      --replace-fail "$out/lib/$pname/${project}" "${lib.getExe dotnet-runtime}\" \"$out/lib/$pname/${project}.dll"
  '';

  passthru = {
    tests =
      let
        with-sdk =
          sdk:
          runCommand "with-${if sdk ? version then sdk.version else "no"}-sdk"
            {
              nativeBuildInputs = [
                finalAttrs.finalPackage
                sdk
                expect
              ];
              meta.timeout = 60;
            }
            # run a LSP handshake rather than matching startup logs -
            # those go through a StreamWriter that upstream never flushes
            ''
              HOME=$TMPDIR
              expect <<"EOF"
                set timeout 60
                set req "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"processId\":null,\"rootUri\":null,\"capabilities\":{}}}"

                set chan [open "|${finalAttrs.meta.mainProgram} --stdio --extensionLogDirectory log 2>@stderr" r+]
                fconfigure $chan -translation binary -buffering none
                spawn -open $chan
                match_max 100000

                send -- "Content-Length: [string length $req]\r\n\r\n$req"
                expect {
                  -ex {"id":1,"result"} { }
                  timeout { send_error "\ntimeout!\n"; exit 1 }
                  eof { send_error "\nserver exited!\n"; exit 1 }
                }
              EOF
              touch $out
            '';
      in
      {
        # Make sure we can run with any supported SDK version, as well as without
        with-net8-sdk = with-sdk dotnetCorePackages.sdk_8_0;
        with-net9-sdk = with-sdk dotnetCorePackages.sdk_9_0;
        with-net10-sdk = with-sdk dotnetCorePackages.sdk_10_0;
        no-sdk = with-sdk null;
        version = testers.testVersion { package = finalAttrs.finalPackage; };
      };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/dotnet/vscode-csharp";
    description = "Language server behind C# Dev Kit for Visual Studio Code";
    changelog = "https://github.com/dotnet/vscode-csharp/releases/tag/v${finalAttrs.vsVersion}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "Microsoft.CodeAnalysis.LanguageServer";
  };
})
