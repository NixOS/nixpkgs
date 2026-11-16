{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "mpf-check";
  version = "3.11.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "MPF";
    tag = finalAttrs.version;
    hash = "sha256-i+Kq72skWBqCQwtibaBhztuRsJSU1bIwSaTmM8u4ARU=";
  };

  postPatch = ''
    substituteInPlace MPF.Frontend/Options.cs \
      --replace-fail 'CheckForUpdatesOnStartup { get; set; } = true;' 'CheckForUpdatesOnStartup { get; set; } = false;'
    substituteInPlace MPF.Frontend/Tools/OptionsLoader.cs \
      --replace-fail '"CheckForUpdatesOnStartup", true)' '"CheckForUpdatesOnStartup", false)'
  '';

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  dotnetFlags = [
    "-p:TargetFramework=net10.0"
    "-p:TreatWarningsAsErrors=false"
  ];

  # vstest can't bind IPv6 loopback in the darwin sandbox
  dotnetTestFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--environment"
    "DOTNET_SYSTEM_NET_DISABLEIPV6=1"
  ];

  executables = [ "MPF.Check" ];
  nugetDeps = ./deps.json;
  projectFile = "MPF.Check/MPF.Check.csproj";

  testProjectFile = [
    "MPF.ExecutionContexts.Test/MPF.ExecutionContexts.Test.csproj"
    "MPF.Frontend.Test/MPF.Frontend.Test.csproj"
    "MPF.Processors.Test/MPF.Processors.Test.csproj"
  ];

  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Validator for the output of redumper, Aaru, DiscImageCreator and other dumping programs";
    homepage = "https://github.com/SabreTools/MPF";
    changelog = "https://github.com/SabreTools/MPF/blob/${finalAttrs.src.tag}/CHANGELIST.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "MPF.Check";
  };
})
