{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
}:

buildDotnetModule rec {
  version = "1.0.0";
  pname = "PS2PatchElf";

  src = fetchFromGitHub {
    owner = "CaptainSwag101";
    repo = "PS2PatchElf";
    tag = "v${version}";
    hash = "sha256-iQL3tT71UOEFIYBdf9BNLUM4++Fm9qEhr77NkMCZdrU=";
  };

  patches = [
    ./patches/fix_arg_check.patch
  ];

  postPatch = ''
    substituteInPlace PS2PatchElf/PS2PatchElf.csproj PS2PatchLib/PS2PatchLib.csproj \
      --replace-fail '<TargetFramework>net6.0</' '<TargetFramework>net10.0</'
  '';

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  nugetDeps = ./deps.json;

  projectFile = "PS2PatchElf/PS2PatchElf.csproj";

  meta = {
    homepage = "https://github.com/CaptainSwag101/PS2PatchElf/";
    description = "Very basic tool for converting PCSX2 .pnach cheats to game executable patches";
    maintainers = [ lib.maintainers.gigahawk ];
    mainProgram = "PS2PatchElf";
    license = lib.licenses.gpl3Only;
  };
}
