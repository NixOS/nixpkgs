{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:

buildDotnetGlobalTool {
  pname = "dotnet-ef";
  version = "10.0.0";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nugetHash = "sha256-GcWo4MARlrq2sWmjJ+zgaTWpMd4kfyQyTNUj4ufG8qg=";

  meta = {
    description = "Tools to help with design-time development tasks";
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
