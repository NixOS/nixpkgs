{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "6.3.16";

  nugetHash = "sha256-4tRdYf+/Q1iedx+DDuIKVGlIWQdr6erM51VdKzZkhCs=";

  meta = {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
