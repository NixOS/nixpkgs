{ stdenv, fetchurl, autoPatchelfHook, makeWrapper, xdg_utils, dbus, qtbase, qtwebkit, qtx11extras, qtquickcontrols, glibc, libXrandr, libX11 }:


stdenv.mkDerivation rec {
  name = "teamviewer-${version}";
  version = "14.2.2558";

  src = fetchurl {
    url = "https://dl.tvcdn.de/download/linux/version_14x/teamviewer_${version}_amd64.deb";
    sha256 = "1wfdvs0jfhm1ri1mni4bf9qszzca17p07w6ih7k4k0x4j8ga18cs";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
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
    wrapProgram $out/share/teamviewer/tv_bin/script/teamviewer --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libXrandr libX11 ]}"
    wrapProgram $out/share/teamviewer/tv_bin/teamviewerd --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libXrandr libX11 ]}"
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = http://www.teamviewer.com;
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jagajaga dasuxullebt ];
  };
}
