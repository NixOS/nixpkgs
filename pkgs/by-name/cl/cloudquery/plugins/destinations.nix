{
  buildOfficialPlugin,
  fetchOfficialPlugin,
}:

# Destination plugins for CloudQuery
{
  postgresql = buildOfficialPlugin (fa: {
    pluginType = "destination";
    pluginName = "postgresql";
    # Versions newer than 8.8.8 require Go v1.24.4+
    version = "8.8.8";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-smvaLG5ebq4J8A3C37DUiTNA8B57K0LDEnB8WJsDfuA=";
    };
    vendorHash = "sha256-7AYf5OpQX0aW8VfVKbzJTK4eHY2qFCmhkdU21cqiQ7k=";
    doCheck = false;
    meta = {
      description = "PostgreSQL destination plugin for CloudQuery";
    };
  });
}
