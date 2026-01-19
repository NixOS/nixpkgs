{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "docfx";
  version = "2.78.4";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetHash = "sha256-VvrKQjOnQ7RGp1hP+Bldi7CaM6qpfp4InB5rESISqEg=";

  meta = {
    description = "Build your technical documentation site with docfx, with landing pages, markdown, API reference docs for .NET, REST API and more";
    homepage = "https://github.com/dotnet/docfx";
    license = lib.licenses.mit;
    mainProgram = "docfx";
    maintainers = with lib.maintainers; [ semtexerror ];
  };
}
