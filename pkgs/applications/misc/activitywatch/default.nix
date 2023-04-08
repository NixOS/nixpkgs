{ config, lib, stdenv, fetchzip, qt6, wrapGAppsNoGuiHook, glib-networking
, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "ActivityWatch";
  version = "0.12.1";

  src = fetchzip {
    url = "https://github.com/ActivityWatch/activitywatch/releases/download/v${version}/activitywatch-v${version}-linux-x86_64.zip";
    hash = "sha256-VdnAKcLQBWBVZqRyD1xoYuAfvTeCtcFJp3/slkQ6ynk=";
  };

  buildInputs = [ qt6.qtbase glib-networking ];
  nativeBuildInputs = [ autoPatchelfHook wrapGAppsNoGuiHook ];
  dontWrapQtApps = true;

  installPhase = ''
    installed=$out/opt/activitywatch
    mkdir -p $out/bin $out/share/applications $out/opt/activitywatch
    mv * $installed

    # Symlink executables to /bin
    ln -s $installed/aw-qt $out/bin/aw-qt
    for name in aw-server aw-server-rust aw-watcher-afk aw-watcher-window; do
      ln -s $installed/$name/$name $out/bin/$name
    done

    # Add .desktop file to share/applications
    cp $installed/aw-qt.desktop $out/share/applications

    # Add logo to share/icons
    mkdir -p $out/share/icons/hicolor/{128x128,512x512}/apps
    ln -s $installed/media/logo/logo.png $out/share/icons/hicolor/512x512/apps/activitywatch.png
    ln -s $installed/media/logo/logo-128.png $out/share/icons/hicolor/128x128/apps/activitywatch.png
  '';

  meta = with lib; {
    description = "ActivityWatch is an app that automatically tracks how you spend time on your devices.";
    longDescription = ''
      ActivityWatch is an app that automatically tracks how you spend time on your devices.
      It is open source, privacy-first, cross-platform, and a great alternative to services like RescueTime, ManicTime, and WakaTime.
      It can be used to keep track of your productivity, time spent on different projects, bad screen habits, or just to understand how you spend your time.
    '';
    homepage = "https://github.com/ActivityWatch/activitywatch";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaoky ];
  };
}
