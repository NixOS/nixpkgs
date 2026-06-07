{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "inklecate";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "inkle";
    repo = "ink";
    rev = "v${version}";
    hash = "sha256-IEYn7GHUTLABGVZH2AYUpbGeuZvUPbwHz5GcuMrRem8=";
  };

  postPatch = ''
    find . -name "*.csproj" -exec sed -i 's/net6.0/net8.0/g' {} +
    find . -name "*.csproj" -exec sed -i 's/netstandard2.0/net8.0/g' {} +
    find . -name "*.csproj" -exec sed -i 's/netstandard1.0;//g' {} +
  '';

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  projectFile = "inklecate/inklecate.csproj";
  nugetDeps = ./deps.json;
  executables = [ "inklecate" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  meta = {
    description = "Compiler for ink, inkle's scripting language";
    mainProgram = "inklecate";
    longDescription = ''
      Inklecate is a command-line compiler for ink, inkle's open source
      scripting language for writing interactive narrative
    '';
    homepage = "https://www.inklestudios.com/ink/";
    downloadPage = "https://github.com/inkle/ink/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.aarch64;
    maintainers = [ ];
  };
}
