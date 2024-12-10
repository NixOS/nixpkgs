{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.4.3";

  nugetHash = "sha256-R6dmF3HPI2BAcNGLCm6WwBlk4ev6T6jaiJUAWYKf2S4=";

  meta = with lib; {
    description = "CLI for managing Akka.NET applications and Akka.NET Clusters";
    homepage = "https://cmd.petabridge.com/index.html";
    changelog = "https://cmd.petabridge.com/articles/RELEASE_NOTES.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anpin mdarocha ];
    mainProgram = "pbm";
  };
}
