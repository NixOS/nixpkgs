{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildDotnetModule (finalAttrs: {
  pname = "kosync-dotnet";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jberlyn";
    repo = "kosync-dotnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FmjUmY2UDWrjc2npcEdrWzVLfICPa6kpNGEcAkqlP4o=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  projectFile = "Kosync.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  executables = [ "Kosync" ];

  postFixup = ''
    mv $out/bin/Kosync $out/bin/kosync-dotnet
  '';

  passthru = {
    tests = { inherit (nixosTests) kosync-dotnet; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hostable implementation of the KOReader sync server";
    homepage = "https://github.com/jberlyn/kosync-dotnet";
    changelog = "https://github.com/jberlyn/kosync-dotnet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "kosync-dotnet";
    maintainers = with lib.maintainers; [ notthebee ];
    platforms = lib.platforms.unix;
  };
})
