{ appimageTools, fetchurl, gsettings-desktop-schemas, gtk3, lib }:

let
  pname = "station";
  version = "1.51.1";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/getstation/desktop-app-releases/releases/download/${version}/Station-${version}.AppImage";
    sha256 = "1vfis2q7zf1sabdlxzmbxh135jk25ylhavrgfc30k5nad9cacw8k";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null;
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "A single place for all of your web applications";
    homepage = "https://getstation.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lattfein ];
  };
}
