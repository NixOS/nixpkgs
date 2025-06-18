{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.4.4";

  nugetHash = "sha256-2MoIpgBDrjbi2nInGxivgjLSnS/iyv01y0Yia8R/Gyc=";

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
