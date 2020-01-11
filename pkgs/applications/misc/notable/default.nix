{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "notable";
  version = "1.7.3";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/notable/notable/releases/download/v${version}/Notable-${version}.AppImage";
    sha256 = "1a7xpdk23np398nrgivyp8z54idqm72dfwx67i2rmxa3dnmcxkvl";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "The markdown-based note-taking app that doesn't suck";
    homepage = https://github.com/notable/notable;
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
