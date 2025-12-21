{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "7.0.5";

  nugetHash = "sha256-fseS0ORahl/iK/uZmGOooTmrny8YL1KEwNNq27VxLj0=";

  meta = {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
