{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "fantomas";
  version = "6.2.3";

  nugetSha256 = "sha256-Aol10o5Q7l8s6SdX0smVdi3ec2IgAx+gMksAMjXhIfU=";

  meta = with lib; {
    description = "F# source code formatter";
    homepage = "https://github.com/fsprojects/fantomas";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "fantomas";
  };
}
