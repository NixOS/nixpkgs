{
  buildDotnetGlobalTool,
  dotnetCorePackages,
  lib,
}:

buildDotnetGlobalTool {
  pname = "csharprepl";
  nugetName = "CSharpRepl";
  version = "0.6.6";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  # We're using an SDK here because it's a REPL, and it requires an SDK instaed of a runtime
  dotnet-runtime = dotnetCorePackages.sdk_8_0;

  nugetHash = "sha256-VkZGnfD8p6oAJ7i9tlfwJfmKfZBHJU7Wdq+K4YjPoRs=";

  meta = {
    description = "C# REPL with syntax highlighting";
    homepage = "https://fuqua.io/CSharpRepl";
    changelog = "https://github.com/waf/CSharpRepl/blob/main/CHANGELOG.md";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ donteatoreo ];
    mainProgram = "csharprepl";
  };
}
