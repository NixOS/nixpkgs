{
  fetchFromGitHub,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "patchcil";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "GGG-KILLER";
    repo = "patchcil";
    tag = "v${version}";
    hash = "sha256-WIR1uzAjn1s2+soANBpA3qzpGEQ+BwcfYcsplTC2rEg=";
  };

  projectFile = "src/PatchCil.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  dotnetFlags = [
    # Don't include error messages for other languages.
    # The main program itself doesn't have them so these would be inconsistent with the rest.
    "-p:SatelliteResourceLanguages=en"
  ];

  executables = [ "patchcil" ];

  meta = {
    description = "A small utility to modify the library paths from PInvoke in .NET assemblies.";
    homepage = "https://github.com/GGG-KILLER/patchcil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ggg ];
    mainProgram = "patchcil";
    # We run pretty much wherever .NET will let us.
    inherit (dotnetCorePackages.runtime_9_0.meta) platforms;
  };
}
