{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.4.5";

  nugetHash = "sha256-iwacwYa1bB51Wp7PvrUclJ+Rdn0yzZa0EKcBwbpGSag=";

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
