{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  powershell,
  darwin,
  glibcLocales,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "ilspycmd";
  version = "11.1";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AaXFnAEugUdQ1MUx31rYS/9H+bUlenGCRwOxLXkIMnk=";
  };

  nativeBuildInputs = [
    powershell
  ]
  ++ lib.optionals (stdenvNoCC.hostPlatform.isDarwin && stdenvNoCC.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = lib.optionalString stdenvNoCC.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dotnet-sdk = dotnetCorePackages.sdk_11_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  # Nixpkgs restores one runtime ID at a time, while upstream locks several.
  dotnetRestoreFlags = [ "--force-evaluate" ];

  projectFile = "ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj";
  nugetDeps = ./deps.json;
  passthru.updateScript = nix-update-script { };

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;

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
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [
      emilytrau
      tbaldwin
      bad3r
    ];
  };
})
