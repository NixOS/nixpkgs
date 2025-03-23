{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "dotnet-ef";
  version = "9.0.2";

  nugetHash = "sha256-aevR1w8IDXrRLnrR5ax2BaAjGpjOWuBKJ9TzI43p7mc=";

  meta = {
    description = "The Entity Framework Core tools help with design-time development tasks.";
    longDescription = ''
      The Entity Framework Core tools help with design-time development tasks.
      They're primarily used to manage Migrations and to scaffold a DbContext and entity types by reverse engineering the schema of a database.
    '';
    downloadPage = "https://www.nuget.org/packages/dotnet-ef";
    homepage = "https://learn.microsoft.com/en-us/ef/core/cli/dotnet";
    changelog = "https://learn.microsoft.com/en-us/ef/core/what-is-new/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lostmsu ];
    mainProgram = "dotnet-ef";
  };
}
