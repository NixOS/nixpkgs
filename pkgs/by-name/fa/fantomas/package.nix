{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "7.0.6";

  nugetHash = "sha256-DWGyesmP5bCO/hMNlo19DRkoCBC64l/K9DNiWbaDeg4=";

  meta = {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
