{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenv,
  nix-update-script,
  aot ? true,
}:

buildDotnetModule rec {
  pname = "patchcil";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "GGG-KILLER";
    repo = "patchcil";
    tag = "v${version}";
    hash = "sha256-4Gl9xpO2YHo3t+MhJTjV/jmChvjO8vFCix6En1T/RfQ=";
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
    description = "A small utility to modify the library paths from PInvoke in .NET assemblies.";
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
