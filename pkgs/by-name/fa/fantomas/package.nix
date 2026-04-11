{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "7.0.3";

  nugetHash = "sha256-0XlfV7SxXPDnk/CjkUesJSaH0cxlNHJ+Jj86zNUhkNA=";

  meta = {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
