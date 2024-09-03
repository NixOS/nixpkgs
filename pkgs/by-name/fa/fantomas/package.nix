{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "6.3.11";

  nugetHash = "sha256-11bHGEAZTNtdp2pTg5zqLrQiyI/j/AT7GGL/2CR4+dw=";

  meta = with lib; {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
