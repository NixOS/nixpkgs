{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenv,
  nix-update-script,
  aot ? dotnetCorePackages.sdk_9_0.hasILCompiler && !stdenv.hostPlatform.isDarwin,
}:

buildDotnetModule rec {
  pname = "patchcil";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "GGG-KILLER";
    repo = "patchcil";
    tag = "v${version}";
    hash = "sha256-jqVXKp5ShWkIMAgmcwu9/QHy+Ey9d1Piv62wsO0Xm44=";
  };

  nativeBuildInputs = lib.optional aot stdenv.cc;

  projectFile = "src/PatchCil.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = if aot then null else dotnetCorePackages.runtime_9_0;

  selfContainedBuild = aot;
  dotnetFlags = lib.optionals (!aot) [
    # Disable AOT
    "-p:PublishAot=false"
    "-p:InvariantGlobalization=false"
    "-p:EventSourceSupport=true"
    "-p:HttpActivityPropagationSupport=true"
    "-p:MetadataUpdaterSupport=true"
    "-p:MetricsSupport=true"
    "-p:UseNativeHttpHandler=false"
    "-p:XmlResolverIsNetworkingEnabledByDefault=true"
    "-p:EnableGeneratedComInterfaceComImportInterop=true"
    "-p:_ComObjectDescriptorSupport=true"
    "-p:_DataSetXmlSerializationSupport=true"
    "-p:_DefaultValueAttributeSupport=true"
    "-p:_DesignerHostSupport=true"
    "-p:_EnableConsumingManagedCodeFromNativeHosting=true"
    "-p:_UseManagedNtlm=true"
  ];

  preFixup = lib.optionalString aot ''
    # Remove debug symbols as they shouldn't have anything in them.
    rm $out/lib/patchcil/patchcil.dbg
  '';

  executables = [ "patchcil" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small utility to modify the library paths from PInvoke in .NET assemblies";
    homepage = "https://github.com/GGG-KILLER/patchcil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ggg ];
    mainProgram = "patchcil";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
      "i686-windows"
    ];
  };
}
