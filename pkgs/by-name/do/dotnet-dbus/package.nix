{ buildDotnetGlobalTool, lib }:

buildDotnetGlobalTool {
  pname = "dotnet-dbus";
  version = "0.21.2";

  nugetName = "Tmds.DBus.Tool";
  nugetHash = "sha256-PUJ0hvKJT/gReWkiBffw8B/oSPG/rNXISidwEQF8uzA=";

  meta = with lib; {
    description = "dotnet-dbus - Tmds.DBus tool for generating C# code from D-Bus XML interface descriptions";
    longDescription = ''
      Tmds.DBus is a library that can be used to connect to D-Bus from .NET applications.
      This tool helps generate C# code from D-Bus XML interface descriptions.
    '';
    downloadPage = "https://www.nuget.org/packages/Tmds.DBus.Tool";
    homepage = "https://github.com/tmds/Tmds.DBus";
    changelog = "https://github.com/tmds/Tmds.DBus/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ lostmsu ];
    mainProgram = "dotnet-dbus";
  };
}
