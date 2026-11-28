{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "ps2patchelf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CaptainSwag101";
    repo = "PS2PatchElf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iQL3tT71UOEFIYBdf9BNLUM4++Fm9qEhr77NkMCZdrU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/CaptainSwag101/PS2PatchElf/";
    changelog = "https://github.com/CaptainSwag101/PS2PatchElf/releases/tag/${finalAttrs.src.tag}";
    description = "Very basic tool for converting PCSX2 .pnach cheats to game executable patches";
    maintainers = [ lib.maintainers.gigahawk ];
    mainProgram = "PS2PatchElf";
    license = lib.licenses.gpl3Only;
  };
})
