{
  lib,
  buildDotnetGlobalTool,
}:

buildDotnetGlobalTool rec {
  pname = "dotnet-gitversion";
  nugetName = "GitVersion.Tool";
  version = "6.4.0";

  nugetHash = "sha256-0mVKDxvencguu/s8BFRSdmULJQITEbb6cf3ZzvRnw5o=";

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
