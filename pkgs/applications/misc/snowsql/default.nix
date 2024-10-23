{
  stdenvNoCC,
  callPackage,
  lib,
}:
let
  pname = "snowsql";
  version = "1.3.0";
  meta = with lib; {
    description = "Command line client for the Snowflake database";
    homepage = "https://www.snowflake.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ andehen ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "snowsql";
  };
in
if stdenvNoCC.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
