{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "7.0.2";

  nugetHash = "sha256-BAaENIm/ksTiXrUImRgKoIXTGIlgsX7ch6ayoFjhJXA=";

  meta = with lib; {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
