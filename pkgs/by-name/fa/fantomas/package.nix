{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "6.3.12";

  nugetHash = "sha256-LFZn2cO72FlsmLI0vTLz52Bn4XBeGILTOr8rz/EuXeg=";

  meta = with lib; {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
