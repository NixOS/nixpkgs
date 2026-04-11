{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.5.0";

  nugetHash = "sha256-MDsu9+EtgiDXPHKDMkbfzekPts064g39tbGJj9vSGMc=";

  meta = {
    description = "CLI for managing Akka.NET applications and Akka.NET Clusters";
    homepage = "https://cmd.petabridge.com/index.html";
    changelog = "https://cmd.petabridge.com/articles/RELEASE_NOTES.html";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      anpin
      mdarocha
    ];
    mainProgram = "pbm";
  };
}
