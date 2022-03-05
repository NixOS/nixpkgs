{ lib, stdenv, fetchFromGitHub, buildDotnetModule, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "formula-dotnet";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "VUISIS";
    repo = "formula-dotnet";
    rev = "e962438022350dca64335c0603c00d44cb10b528";
    sha256 = "sha256-hVtwV1MdsXaN6ZrGW4RG2HcNcv/hys/5VxGjH9vFdRE=";
  };

  nugetDeps = ./nuget.nix;
  projectFile = "Src/CommandLine/CommandLine.csproj";

  postFixup = if stdenv.isLinux then ''
    mv $out/bin/CommandLine $out/bin/formula
  '' else lib.optionalString stdenv.isDarwin ''
    makeWrapper ${dotnetCorePackages.runtime_5_0}/bin/dotnet $out/bin/formula \
      --add-flags "$out/lib/formula-dotnet/CommandLine.dll" \
      --prefix DYLD_LIBRARY_PATH : $out/lib/formula-dotnet/runtimes/macos/native
  '';

  meta = with lib; {
    description = "Formal Specifications for Verification and Synthesis";
    homepage = "https://github.com/VUISIS/formula-dotnet";
    license = licenses.mspl;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
