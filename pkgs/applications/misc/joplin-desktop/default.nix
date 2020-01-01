{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "joplin-desktop";
  version = "1.0.177";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}.AppImage";
    sha256 = "023q3yxqsv0vd76bvfhyhh0pnfia01rflfpyv0i6w6xnb5hm2jp7";
  };


  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "An open source note taking and to-do application with synchronisation capabilities";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = https://joplin.cozic.net/;
    license = licenses.mit;
    maintainers = with maintainers; [ rafaelgg raquelgb ];
    platforms = [ "x86_64-linux" ];
  };
}
