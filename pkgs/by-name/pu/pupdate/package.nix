{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "pupdate";
  version = "5.10.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mattpannella";
    repo = "pupdate";
    tag = finalAttrs.version;
    hash = "sha256-up5teudXfI9RKRePp/pCs0ubXKDp8jU6uA1a40OX1x8=";
  };

  projectFile = "pupdate.csproj";
  testProjectFile = "tests/pupdate.Tests/pupdate.Tests.csproj";
  nugetDeps = ./deps.json;

  dotnetInstallFlags = [ "-p:PublishSingleFile=false" ];

  executables = [ "pupdate" ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Update utility for the openFPGA cores, firmware, and other stuff on your Analogue Pocket";
    homepage = "https://github.com/mattpannella/pupdate";
    changelog = "https://github.com/mattpannella/pupdate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "pupdate";
  };
})
