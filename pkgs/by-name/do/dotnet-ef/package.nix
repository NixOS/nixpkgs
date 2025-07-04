{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "dotnet-ef";
  version = "9.0.6";

  nugetHash = "sha256-dHOGvqdIfYhuAz7JwQoG/4uJNE9wpfI/dnL4zj3lD6A=";

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
