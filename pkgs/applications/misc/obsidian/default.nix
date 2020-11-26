{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3}:

let
  pname = "obsidian";
  version = "0.8.2";
in

appimageTools.wrapType2 rec {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage";
    sha256 = "04jgsd97ivdm84diiafwqxzc9vvga1gsr7xicmqhdq05ns3xsfyz";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  # Strip version from binary name.
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files.";
    homepage = "https://obsidian.md";
    license = licenses.obsidian;
    maintainers = with maintainers; [ conradmearns ];
    platforms = [ "x86_64-linux" ];
  };
}