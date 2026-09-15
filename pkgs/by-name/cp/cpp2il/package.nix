{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  xmlstarlet,
  capstone_4,
  versionCheckHook,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: rec {
  pname = "cpp2il";
  version = "2022.1.0-pre-release.19";

  src = fetchFromGitHub {
    owner = "SamboyCoding";
    repo = "Cpp2IL";
    rev = version;
    hash = "sha256-itXWi0j6bQ3lKwsSEO7QSvTW4hrO1HdSJ+2GQQlB25w=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  projectFile = [ "Cpp2IL/Cpp2IL.csproj" ];
  nugetDeps = ./deps.json;

  nativeBuildInputs = [
    xmlstarlet
  ];

  runtimeDeps = [
    capstone_4
  ];

  postPatch = ''
    # Remove sam's nigthly nuget repo which isn't needed for release builds
    rm nuget.config

    # Reduce the amount of frameworks we have to pull in
    xmlstarlet edit --inplace --rename '//TargetFrameworks' --value 'TargetFramework' **/*.csproj
    xmlstarlet edit --inplace --update '//TargetFramework' --value 'net${lib.versions.majorMinor finalAttrs.dotnet-runtime.version}' **/*.csproj
  '';

  postInstall = ''
    # Remove the prebuilt capstone binary, we provide our own
    rm "$out/lib/cpp2il/libcapstone${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Work-in-progress tool to reverse Unity's IL2CPP toolchain";
    homepage = "https://github.com/SamboyCoding/Cpp2IL";
    changelog = "https://github.com/SamboyCoding/Cpp2IL/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ js6pak ];
    mainProgram = "Cpp2IL";
  };
})
