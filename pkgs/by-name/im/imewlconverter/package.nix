{
  fetchFromGitHub,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule {
  pname = "imewlconverter";
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "studyzy";
    repo = "imewlconverter";
    rev = "v3.1.1";
    hash = "sha256-lrYqQWh+PZreJ6oJg+OCipiqUyfG/2moP/n+jR+Kcj8=";
  };

  projectFile = "src/ImeWlConverterCmd/ImeWlConverterCmd.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  meta = {
    mainProgram = "ImeWlConverterCmd";
    description = "FOSS program for converting IME dictionaries";
    homepage = "https://github.com/studyzy/imewlconverter";
    maintainers = with lib.maintainers; [ xddxdd ];
    license = lib.licenses.gpl3Only;
  };
}
