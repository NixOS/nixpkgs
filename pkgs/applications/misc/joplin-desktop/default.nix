{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3, makeDesktopItem }:

let
  pname = "joplin-desktop";
  version = "1.0.233";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}.AppImage";
    sha256 = "1fmk56b9b70ly1r471mhppr8fz1wm2gpxji1v760ynha8fqy7qg1";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/joplin.desktop $out/share/applications/joplin.desktop
    install -m 444 -D ${appimageContents}/joplin.png \
      $out/share/pixmaps/joplin.png
    substituteInPlace $out/share/applications/joplin.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';


  meta = with lib; {
    description = "An open source note taking and to-do application with synchronisation capabilities";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = "https://joplinapp.org";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = [ "x86_64-linux" ];
  };
}
