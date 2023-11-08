{ stdenv
, copyDesktopItems
, buildFHSEnv
, makeDesktopItem
, makeWrapper
}:

{ pname, version, src, meta }:
let
  fhsEnv = buildFHSEnv {
    name = "${pname}-fhs-env";
    runScript = "";

    targetPkgs = pkgs: with pkgs; [
      xkeyboard_config
      udev
    ];

    multiPkgs = pkgs: with pkgs; [
      cups
      dbus
      expat
      fontconfig
      freetype
      gccForLibs
      glib
      libglvnd
      libinput
      libxkbcommon
      nss
      nspr
      xorg.libX11
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      zlib
    ];
  };
in
stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/libexec/$pname $out/share/icons/hicolor/scalable/apps
    cp -r bin lib $out/libexec/$pname

    for app in p4admin p4merge p4v p4vc; do
      makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/bin/$app \
        --add-flags $out/libexec/$pname/bin/$app
    done

    for app in p4admin p4merge p4v; do
      cp lib/P4VResources/icons/$app.svg $out/share/icons/hicolor/scalable/apps/
    done

    runHook postInstall
  '';

  desktopItems = map
    ({ name, desktopName, genericName, comment }: makeDesktopItem {
      inherit name desktopName genericName comment;
      exec = name;
      icon = name;
      categories = [
        "Development"
        "RevisionControl"
      ];
    })
    [
      {
        name = "p4admin";
        desktopName = "P4Admin";
        genericName = "Helix Admin Tool";
        comment = "Manage and monitor Helix Core users and SCM operations";
      }
      {
        name = "p4merge";
        desktopName = "P4Merge";
        genericName = "Helix Visual Merge Tool";
        comment = "A three-way merging and side-by-side file comparison tool";
      }
      {
        name = "p4v";
        desktopName = "P4V";
        genericName = "Helix Visual Client";
        comment = "Graphical interface to versioned files in Helix Core";
      }
    ];
}
