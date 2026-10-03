{
  lib,
  buildDotnetModule,
  fetchFromGitLab,
}:

buildDotnetModule (finalAttrs: {
  pname = "ryuldn";
  version = "0-unstable-2025-11-10";

  src = fetchFromGitLab {
    domain = "git.ryujinx.app";
    owner = "Ryubing";
    repo = "ldn";
    rev = "a0c24aab984cfeb93428cae29e35296a880ff6fa";
    hash = "sha256-l4twKew1+nMQIslFUiZzX2La1uptGx3Fqmh30pZlyuk=";
  };

  projectFile = "LanPlayServer.csproj";
  nugetDeps = ./deps.json;

  dotnetFlags = [ "-p:PublishAOT=false" ];

  postInstall = "cp ${finalAttrs.src}/Utils/gamelist.json $out";

  meta = {
    homepage = "https://ldn.ryujinx.app";
    description = "Backend server for using LDN functionality for playing with those who aren't local.";
    longDescription = ''
      This server drives multiplayer "matchmaking" in Ryujinx's local wireless implementation.
      Players can create "networks" on the server, which can then be scanned and found by other players
      as if they were within that network's range. The server entirely manages the network information
      and player join/leave lifecycle for all games created.
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.unix;
    mainProgram = "LanPlayServer";
  };
})
