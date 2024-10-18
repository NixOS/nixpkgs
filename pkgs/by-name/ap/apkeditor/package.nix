{
  lib,
  buildEnv,
  fetchurl,
  jre,
  writeShellScriptBin,
}:

let
  pname = "apkeditor";
  version = "1.4.1";

  jar = fetchurl {
    url = "https://github.com/REAndroid/APKEditor/releases/download/V${version}/APKEditor-${version}.jar";
    hash = "sha256-SpiuanVSZDV2A/GQa5LmLnV9WSKQFOMzlfTgP/AZ/ag=";
  };
in
buildEnv {
  name = "${pname}-${version}";

  paths = [
    (writeShellScriptBin "APKEditor" ''
      exec ${jre}/bin/java -jar ${jar} $@
    '')
  ];

  meta = {
    description = "Powerful android apk resources editor";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://github.com/REAndroid/APKEditor";
    executables = [ "APKEditor" ];
  };

}
