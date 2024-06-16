{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "6.3.9";

  nugetSha256 = "sha256-XRPC5cXMoTJLLHe3f5A3+uXakbL+D7DlX0sA52KMZKw=";

  meta = with lib; {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
