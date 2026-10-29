{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  powershell,
  darwin,
  glibcLocales,
  # gitMinimal,
}:
buildDotnetModule (finalAttrs: {
  pname = "ilspycmd";
  version = "11.2";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0QxVGaWfAfArHHqW8zmPAFHu7X3MmHVLEgDwqF4KS9w=";
    # this isn't deterministic: https://github.com/NixOS/nixpkgs/issues/8567
    # figure out a way to do this using https://github.com/NixOS/nixpkgs/pull/465497
    # required for full version to be set properly
    # leaveDotGit = true;
    # deepClone = true;
  };

  nativeBuildInputs = [
    # gitMinimal
    powershell
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = lib.optionalString stdenvNoCC.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_10_0
      sdk_11_0
    ];

  dotnet-runtime =
    with dotnetCorePackages;
    combinePackages [
      runtime_10_0
      runtime_11_0
    ];

  projectFile = "ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj";
  nugetDeps = ./deps.json;

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;

  # see: https://github.com/NixOS/nixpkgs/issues/454432
  dotnetRestoreFlags = [ "--force-evaluate" ];

  testProjectFile = "ICSharpCode.ILSpyCmd.Tests/ICSharpCode.ILSpyCmd.Tests.csproj";

  # https://github.com/NixOS/nixpkgs/issues/574244
  # The current dotnetCheckPhase does not support Microsoft.Testing.Platform tests
  # The following flags get passed through to the test binary and cause it to error
  # Remove them for now until the hook is updated to add support.
  postBuild = ''
    eval "$(declare -f dotnetCheckPhase | sed \
        -e 's|--logger "console;verbosity=normal"||' \
        -e 's|-maxcpucount:"\$maxCpuFlag"||')"
  '';

  # due to the comments above in fetchFromGitHub, tests are now broken
  # reenable them when that's fixed
  # doCheck = true;

  meta = {
    description = "Tool for decompiling .NET assemblies and generating portable PDBs";
    mainProgram = "ilspycmd";
    homepage = "https://github.com/icsharpcode/ILSpy";
    changelog = "https://github.com/icsharpcode/ILSpy/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      # third party dependencies
      mspl
      asl20
    ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [
      emilytrau
      tbaldwin
    ];
  };
})
