{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "juniper";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "calebh";
    repo = "Juniper";
    rev = "286050d6be5606db0973feda556d8fbc48b4566c";
    hash = "sha256-b+aDDz46Hxgt+Oh2fNMiXFfXhuy16mzauousQGq9+dg=";
  };

  projectFile = "Juniper/Juniper.fsproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  meta = {
    description = "Functional reactive programming language for programming Arduino";
    longDescription = ''
      The purpose of Juniper is to provide a functional reactive programming
      platform for designing Arduino projects. FRP's high-level approach to
      timing-based events fits naturally with Arduino, with which programming
      almost entirely revolves around reacting to realtime events. Juniper
      transpiles to Arduino C++, which is then compiled to an Arduino
      executable.
    '';
    homepage = "https://www.juniper-lang.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AlexSKaye ];
    mainProgram = "Juniper";
    inherit (dotnet-sdk.meta) platforms;
  };
}
