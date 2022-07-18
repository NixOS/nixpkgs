{ mkDerivation, lib, fetchurl, autoPatchelfHook, makeWrapper, xdg-utils, dbus
, qtbase, qtwebkit, qtwebengine, qtx11extras, qtquickcontrols, getconf, glibc
, libXrandr, libX11, libXext, libXdamage, libXtst, libSM, libXfixes, coreutils
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "teamviewer";
  # teamviewer itself has not development files but the dev output removes propagated other dev outputs from runtime
  outputs = [ "out" "dev" ];
  version = "15.29.4";

  src = fetchurl {
    url = "https://dl.tvcdn.de/download/linux/version_15x/teamviewer_${version}_amd64.deb";
    sha256 = "sha256-jkFqOtU+D62S7QmNPvz58Z8wJ79lkN11pWQrtNdD+Uk=";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapQtAppsHook ];
  buildInputs = [ dbus getconf qtbase qtwebkit qtwebengine qtx11extras libX11 ];
  propagatedBuildInputs = [ qtquickcontrols ];

  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin $out/share/applications
    cp -a opt/teamviewer/* $out/share/teamviewer
    rm -R \
      $out/share/teamviewer/logfiles \
      $out/share/teamviewer/config \
      $out/share/teamviewer/tv_bin/RTlib \
      $out/share/teamviewer/tv_bin/xdg-utils \
      $out/share/teamviewer/tv_bin/script/{teamviewer_setup,teamviewerd.sysv,teamviewerd.service,teamviewerd.*.conf,tv-delayed-start.sh}

    ln -s $out/share/teamviewer/tv_bin/script/teamviewer $out/bin
    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin
    ln -s $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop $out/share/applications
    ln -s /var/lib/teamviewer $out/share/teamviewer/config
    ln -s /var/log/teamviewer $out/share/teamviewer/logfiles
    ln -s ${xdg-utils}/bin $out/share/teamviewer/tv_bin/xdg-utils

    declare in_script_dir="./opt/teamviewer/tv_bin/script"

    install -d "$out/share/dbus-1/services"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.service" "$out/share/dbus-1/services"
    substituteInPlace "$out/share/dbus-1/services/com.teamviewer.TeamViewer.service" \
      --replace '/opt/teamviewer/tv_bin/TeamViewer' \
        "$out/share/teamviewer/tv_bin/TeamViewer"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.Desktop.service" "$out/share/dbus-1/services"
    substituteInPlace "$out/share/dbus-1/services/com.teamviewer.TeamViewer.Desktop.service" \
      --replace '/opt/teamviewer/tv_bin/TeamViewer_Desktop' \
        "$out/share/teamviewer/tv_bin/TeamViewer_Desktop"

    install -d "$out/share/dbus-1/system.d"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.Daemon.conf" "$out/share/dbus-1/system.d"

    install -d "$out/share/polkit-1/actions"
    install -m 644 "$in_script_dir/com.teamviewer.TeamViewer.policy" "$out/share/polkit-1/actions"
    substituteInPlace "$out/share/polkit-1/actions/com.teamviewer.TeamViewer.policy" \
      --replace '/opt/teamviewer/tv_bin/script/execscript' \
        "$out/share/teamviewer/tv_bin/script/execscript"

    for i in 16 20 24 32 48 256; do
      size=$i"x"$i

      mkdir -p $out/share/icons/hicolor/$size/apps
      ln -s $out/share/teamviewer/tv_bin/desktop/teamviewer_$i.png $out/share/icons/hicolor/$size/apps/TeamViewer.png
    done;

    sed -i "s,/opt/teamviewer,$out/share/teamviewer,g" $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop

    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_aux \
      --replace '/lib64/ld-linux-x86-64.so.2' '${glibc.out}/lib/ld-linux-x86-64.so.2'
    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_config \
      --replace '/var/run/' '/run/'
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ getconf coreutils ]}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libXrandr libX11 libXext libXdamage libXtst libSM libXfixes dbus ]}"
  ];

  postFixup = ''
    wrapProgram $out/share/teamviewer/tv_bin/teamviewerd ''${makeWrapperArgs[@]}
    # tv_bin/script/teamviewer runs tvw_main which runs tv_bin/TeamViewer
    wrapProgram $out/share/teamviewer/tv_bin/script/teamviewer ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
    wrapProgram $out/share/teamviewer/tv_bin/teamviewer-config ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
    wrapProgram $out/share/teamviewer/tv_bin/TeamViewer_Desktop ''${makeWrapperArgs[@]} ''${qtWrapperArgs[@]}
  '';

  dontStrip = true;
  dontWrapQtApps = true;
  preferLocalBuild = true;

  meta = with lib; {
    homepage = "https://www.teamviewer.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jagajaga jraygauthier ];
  };
}
