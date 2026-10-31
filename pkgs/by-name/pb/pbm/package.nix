{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "pbm";
  version = "1.5.2";

  nugetHash = "sha256-bEx2jOfdqAQ8hVbwnjfT6UizNeVK9DUPbddiomBKdxs=";

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
