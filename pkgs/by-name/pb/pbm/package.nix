{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.4.6";

  nugetHash = "sha256-Rx7L1Bl2VwsAZMGudsFA7K++WuhJpjqlRsHMuBebo6Y=";

  meta = with lib; {
    description = "CLI for managing Akka.NET applications and Akka.NET Clusters";
    homepage = "https://cmd.petabridge.com/index.html";
    changelog = "https://cmd.petabridge.com/articles/RELEASE_NOTES.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      anpin
      mdarocha
    ];
    mainProgram = "pbm";
  };
}
