{
  lib,
  buildDotnetGlobalTool,
}:

buildDotnetGlobalTool rec {
  pname = "dotnet-gitversion";
  nugetName = "GitVersion.Tool";
  version = "5.12.0";

  nugetHash = "sha256-dclYG2D0uSYqf++y33JCefkYLwbuRCuKd3qLMnx3BDI=";

  meta = {
    description = "From git log to SemVer in no time";
    homepage = "https://gitversion.net/";
    changelog = "https://github.com/GitTools/GitVersion/releases/tag/${version}";
    downloadPage = "https://github.com/GitTools/GitVersion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.windows ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ acesyde ];
  };
}
