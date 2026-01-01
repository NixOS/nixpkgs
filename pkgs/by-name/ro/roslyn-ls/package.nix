{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenvNoCC,
  testers,
  jq,
<<<<<<< HEAD
=======
  writeText,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  runCommand,
  expect,
}:
let
  pname = "roslyn-ls";
<<<<<<< HEAD
  # see https://github.com/dotnet/roslyn/blob/main/eng/targets/TargetFrameworks.props
  dotnet-sdk =
    with dotnetCorePackages;
    # required sdk
    sdk_10_0
    // {
      # with additional packages to minimize deps.json
=======
  dotnet-sdk =
    with dotnetCorePackages;
    sdk_10_0
    // {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };
<<<<<<< HEAD
  # should match the default NetVSCode property
  # see https://github.com/dotnet/roslyn/blob/main/eng/targets/TargetFrameworks.props
  dotnet-runtime = dotnetCorePackages.sdk_10_0.runtime;

  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;

  project = "Microsoft.CodeAnalysis.LanguageServer";
=======
  # need sdk on runtime as well
  dotnet-runtime = dotnetCorePackages.sdk_10_0;
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;

  project = "Microsoft.CodeAnalysis.LanguageServer";

  targets = writeText "versions.targets" ''
    <Project>
      <ItemGroup>
        <KnownFrameworkReference Update="@(KnownFrameworkReference)">
          <LatestRuntimeFrameworkVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</LatestRuntimeFrameworkVersion>
          <LatestRuntimeFrameworkVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</LatestRuntimeFrameworkVersion>
          <TargetingPackVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</TargetingPackVersion>
          <TargetingPackVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</TargetingPackVersion>
        </KnownFrameworkReference>
        <KnownAppHostPack Update="@(KnownAppHostPack)">
          <AppHostPackVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</AppHostPackVersion>
          <AppHostPackVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</AppHostPackVersion>
        </KnownAppHostPack>
      </ItemGroup>
    </Project>
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildDotnetModule (finalAttrs: rec {
  inherit pname dotnet-sdk dotnet-runtime;

<<<<<<< HEAD
  vsVersion = "2.111.2-prerelease";
=======
  vsVersion = "2.102.30-prerelease";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
<<<<<<< HEAD
    hash = "sha256-oP+mKOvsbc+/NnqJvounE75BlE6UJTIAnmYTBNQlMFA=";
=======
    hash = "sha256-C61Zew0W1r1klw3zGZfv3YNhZ7SrCd0UbGlXhqkfrbI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
<<<<<<< HEAD
  version = "5.3.0-2.25604.5";
=======
  version = "5.3.0-2.25568.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
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
=======

    substituteInPlace Directory.Build.targets \
      --replace-fail '</Project>' '<Import Project="${targets}" /></Project>'
  '';

  dotnetFlags = [
    "-p:TargetRid=${rid}"
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
    # this is needed for the KnownAppHostPack changes to work
    "-p:EnableAppHostPackDownload=true"
  ];

  # two problems solved here:
  # 1. --no-build removed -> BuildHost project within roslyn is running Build target during publish
  # 2. missing crossgen2 7.* in local nuget directory when PublishReadyToRun=true
  # the latter should be fixable here but unsure how
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  installPhase = ''
    runHook preInstall

    env dotnet publish $dotnetProjectFiles \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        -p:InformationalVersion=$version \
<<<<<<< HEAD
        -p:PublishTrimmed=false \
        -p:OverwriteReadOnlyFiles=true \
=======
        -p:UseAppHost=true \
        -p:PublishTrimmed=false \
        -p:PublishReadyToRun=false \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        --configuration Release \
        --no-self-contained \
        --output "$out/lib/$pname" \
        --no-restore \
        --runtime ${rid} \
        ''${dotnetInstallFlags[@]}  \
        ''${dotnetFlags[@]}

    runHook postInstall
  '';

<<<<<<< HEAD
  # force dotnet-runtime to run the dll
  # but keep the wrapper created with useDotnetFromEnv to allow LS to work properly on codebases
  postFixup = ''
    rm -f $out/lib/$pname/${project}
    substituteInPlace $out/bin/${project} \
      --replace-fail "$out/lib/$pname/${project}" "${lib.getExe dotnet-runtime}\" \"$out/lib/$pname/${project}.dll"
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        with-net8-sdk = with-sdk dotnetCorePackages.sdk_8_0;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
