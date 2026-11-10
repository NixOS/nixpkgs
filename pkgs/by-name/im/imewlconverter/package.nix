{
  fetchFromGitHub,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule {
  pname = "imewlconverter";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "studyzy";
    repo = "imewlconverter";
    rev = "v3.3.0";
    hash = "sha256-4O25M91zOGK8nTxT0s7QlIcYYV0erWBErNlc2+BMpGk=";
  };

  projectFile = "src/ImeWlConverterCmd/ImeWlConverterCmd.csproj";
  nugetDeps = ./deps.json;

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
