{
  lib,
  buildDotnetModule,
  fetchFromGitLab,
}:

buildDotnetModule (finalAttrs: {
  pname = "ryuldn";
  version = "0-unstable-2025-05-12";

  src = fetchFromGitLab {
    domain = "git.ryujinx.app";
    owner = "Ryubing";
    repo = "ldn";
    rev = "79a0c3070ae398a37175cfefab4226ec638c5915";
    hash = "sha256-xDmNSDZRXbdbbgLb8pBJo8QtIftH0tykqS6CDmkzXgw=";
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
    maintainers = with lib.maintainers; [ SchweGELBin ];
    platforms = lib.platforms.unix;
    mainProgram = "LanPlayServer";
  };
})
