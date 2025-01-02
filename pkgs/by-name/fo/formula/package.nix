{ lib, stdenv, fetchFromGitHub, buildDotnetModule, dotnetCorePackages, unstableGitUpdater }:

buildDotnetModule rec {
  pname = "formula-dotnet";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "VUISIS";
    repo = "formula-dotnet";
    rev = "8ee2e6abfd4ce038e1d9cb9c8602dec1ed6c0163";
    sha256 = "sha256-2ulv//YV3OqrfFltgUCeDe4rOPC0qqJ+80/D2lIoih8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  nugetDeps = ./nuget.json;
  projectFile = "Src/CommandLine/CommandLine.csproj";

  postFixup = if stdenv.hostPlatform.isLinux then ''
    mv $out/bin/CommandLine $out/bin/formula
  '' else lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper ${dotnetCorePackages.runtime_6_0}/bin/dotnet $out/bin/formula \
      --add-flags "$out/lib/formula-dotnet/CommandLine.dll" \
      --prefix DYLD_LIBRARY_PATH : $out/lib/formula-dotnet/runtimes/macos/native
  '';

  passthru.updateScript = unstableGitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "Formal Specifications for Verification and Synthesis";
    homepage = "https://github.com/VUISIS/formula-dotnet";
    license = licenses.mspl;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
    mainProgram = "formula";
  };
}
