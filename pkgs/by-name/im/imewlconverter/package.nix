{
  fetchFromGitHub,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule {
  pname = "imewlconverter";
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "studyzy";
    repo = "imewlconverter";
    rev = "v3.2.0";
    hash = "sha256-7rKWbLbRCnMmJ9pwqMYZZZujyxbX84g4rFQ/Ms/R+uE=";
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
