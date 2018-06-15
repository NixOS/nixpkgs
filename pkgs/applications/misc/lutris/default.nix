{ stdenv, buildFHSUserEnv, makeDesktopItem, fetchFromGitHub, python3, gtk3
, gobjectIntrospection, wrapGAppsHook, xterm, xrandr }:

let
  inherit (python3.pkgs) buildPythonApplication pyyaml pygobject3 pyxdg evdev;

  lutris = buildPythonApplication rec {
    name = "lutris-${version}";
    version = "v0.4.18";
    enableParallelBuilding = true;
    nativeBuildInputs = [ wrapGAppsHook ];

    src = fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "${version}";
      sha256 = "1pgvk3qaaph1dlkrc5cq2jifr3yqlhnqsfa0wkaqzssh9acd5q9b";
    };

    propagatedBuildInputs = [
      pyyaml pygobject3 pyxdg evdev gtk3 gobjectIntrospection xterm
    ];

    postConfigure = ''
      export HOME=$PWD
      sed -i "/import traceback/a import gi\ngi.require_version('Gtk', '3.0')" \
        lutris/util/system.py
    '';

    makeWrapperArgs = [
      "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
      "--prefix XDG_DATA_DIRS : $out/share"
      "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    ];

    meta = with stdenv.lib; {
      homepage = "https://lutris.net";
      description = "Open Source gaming platform for GNU/Linux";
      license = licenses.gpl3;
      maintainers = with maintainers; [ chiiruno ];
      platforms = platforms.linux;
    };
  };

  desktopItem = makeDesktopItem {
    name = "Lutris";
    exec = "lutris";
    icon = "lutris";
    comment = lutris.meta.description;
    desktopName = "Lutris";
    genericName = "Gaming Platform";
    categories = "Network;Game;Emulator;";
    startupNotify = "false";
  };
in
buildFHSUserEnv rec {
  name = "lutris";
  targetPkgs = pkgs: with pkgs; [ lutris xrandr xterm wine ];
  runScript = "lutris";

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';
}
