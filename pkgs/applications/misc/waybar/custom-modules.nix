{ lib
, stdenvNoCC
, glib
, gobject-introspection
, playerctl
, python3
, waybar
, wrapGAppsHook
}:

{
  mediaplayer = stdenvNoCC.mkDerivation rec {
    pname = "mediaplayer";
    version = waybar.version;

    src = waybar.src;

    dontBuild = true;
    dontConfigure = true;

    strictDeps = true;
    nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];

    propagatedBuildInputs = [
      glib
      playerctl
      python3.pkgs.pygobject3
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer

      wrapProgram $out/bin/waybar-mediaplayer \
        --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
    '';

    doInstallCheck = true;

    installCheckPhase = ''
      if $out/bin/waybar-mediaplayer --help >/dev/null; then
        echo "waybar-mediaplayer --help passed"
      fi
    '';

    meta = waybar.meta // {
      description = "A media player module based on playerctl for Waybar";
      homepage = "https://github.com/Alexays/Waybar/tree/${version}/resources/custom_modules";
      platforms = lib.platforms.linux;
    };
  };
}
