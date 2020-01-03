{ mkDerivation, lib, fetchurl, autoPatchelfHook, makeWrapper, xdg_utils, dbus
, qtbase, qtwebkit, qtx11extras, qtquickcontrols, glibc
, libXrandr, libX11, libXext, libXdamage, libXtst, libSM, libXfixes
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "teamviewer";
  version = "15.0.8397";

  src = fetchurl {
    url = "https://dl.tvcdn.de/download/linux/version_15x/teamviewer_${version}_amd64.deb";
    sha256 = "0bidlwlpzqpba9c0zfasm08vp308hgfnq4pslj1b04v64mlci66s";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapQtAppsHook ];
  buildInputs = [ dbus qtbase qtwebkit qtx11extras libX11 ];
  propagatedBuildInputs = [ qtquickcontrols ];

  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin $out/share/applications
    cp -a opt/teamviewer/* $out/share/teamviewer
    rm -R \
      $out/share/teamviewer/logfiles \
      $out/share/teamviewer/config \
      $out/share/teamviewer/tv_bin/xdg-utils \
      $out/share/teamviewer/tv_bin/script/{teamviewer_setup,teamviewerd.sysv,teamviewerd.service,teamviewerd.*.conf,libdepend,tv-delayed-start.sh}

    ln -s $out/share/teamviewer/tv_bin/script/teamviewer $out/bin
    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin
    ln -s $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop $out/share/applications
    ln -s /var/lib/teamviewer $out/share/teamviewer/config
    ln -s /var/log/teamviewer $out/share/teamviewer/logfiles
    ln -s ${xdg_utils}/bin $out/share/teamviewer/tv_bin/xdg-utils

    sed -i "s,/opt/teamviewer,$out/share/teamviewer,g" $out/share/teamviewer/tv_bin/desktop/com.teamviewer.*.desktop

    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_aux \
      --replace '/lib64/ld-linux-x86-64.so.2' '${glibc.out}/lib/ld-linux-x86-64.so.2'
    substituteInPlace $out/share/teamviewer/tv_bin/script/tvw_config \
      --replace '/var/run/' '/run/'

    wrapProgram $out/share/teamviewer/tv_bin/script/teamviewer --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libXrandr libX11 ]}"
    wrapProgram $out/share/teamviewer/tv_bin/teamviewerd --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libXrandr libX11 ]}"
    wrapProgram $out/share/teamviewer/tv_bin/TeamViewer --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libXrandr libX11 ]}"
    wrapProgram $out/share/teamviewer/tv_bin/TeamViewer_Desktop --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libXrandr libX11 libXext libXdamage libXtst libSM libXfixes ]}"

    wrapQtApp $out/bin/teamviewer
  '';

  dontStrip = true;
  preferLocalBuild = true;

  meta = with lib; {
    homepage = http://www.teamviewer.com;
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jagajaga dasuxullebt ];
  };
}
