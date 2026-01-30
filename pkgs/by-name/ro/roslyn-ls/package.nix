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
buildDotnetModule (finalAttrs: rec {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.113.22-prerelease";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
    hash = "sha256-rGkQfyKoRlEa7L7H9iFQkKTCD4dU3OP97XDtRFRAHnc=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "5.4.0-2.26062.9";
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
    # and useAppHost is not enough, need to explicilty set to false
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
            ''
              HOME=$TMPDIR
              expect <<"EOF"
                spawn ${meta.mainProgram} --stdio --logLevel Information --extensionLogDirectory log
                expect_before timeout {
                  send_error "timeout!\n"
                  exit 1
                }
                expect "Language server initialized"
                send \x04
                expect eof
                catch wait result
                exit [lindex $result 3]
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
    changelog = "https://github.com/dotnet/vscode-csharp/releases/tag/v${vsVersion}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "Microsoft.CodeAnalysis.LanguageServer";
  };
})
