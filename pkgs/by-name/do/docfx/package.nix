{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "docfx";
  version = "2.80.1";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetHash = "sha256-v9cfkqa+GNiLyBVK+asQSHpbju5TzkcE35xZ3/QkFig=";

  meta = {
    description = "Build your technical documentation site with docfx, with landing pages, markdown, API reference docs for .NET, REST API and more";
    homepage = "https://github.com/dotnet/docfx";
    license = lib.licenses.mit;
    mainProgram = "docfx";
    maintainers = with lib.maintainers; [ semtexerror ];
  };
}
