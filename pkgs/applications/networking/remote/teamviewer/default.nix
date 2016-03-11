{ stdenv, lib, fetchurl, xdg_utils, pkgs, pkgsi686Linux }:

let
  version = "11.0.53191";

  ld32 =
    if stdenv.system == "x86_64-linux" then "${stdenv.cc}/nix-support/dynamic-linker-m32"
    else "${stdenv.cc}/nix-support/dynamic-linker";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";

  mkLdPath = ps: lib.makeLibraryPath (with ps; [ qt4 dbus alsaLib ]);

  deps = ps: (with ps; [ dbus alsaLib fontconfig freetype libpng libjpeg ]) ++ (with ps.xlibs; [ libX11 libXext libXdamage libXrandr libXrender libXfixes libSM libXtst ]);
  tvldpath32 = lib.makeLibraryPath (with pkgsi686Linux; [ qt4 "$out/share/teamviewer/tv_bin/wine" ] ++ deps pkgsi686Linux);
  tvldpath64 = lib.makeLibraryPath (deps pkgs);

in
stdenv.mkDerivation {
  name = "teamviewer-${version}";
  src = fetchurl {
    # There is a 64-bit package, but it has no differences apart from Debian dependencies.
    # Generic versioned packages (teamviewer_${version}_i386.tar.xz) are not available for some reason.
    url = "http://download.teamviewer.com/download/teamviewer_${version}_i386.deb";
    sha256 = "1yr4c7d6hymw7kvca2jqxzaz6rw5xr66iby77aknd0v4afh4yzz3";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin $out/share/applications
    cp -a opt/teamviewer/* $out/share/teamviewer
    rm -R \
      $out/share/teamviewer/logfiles \
      $out/share/teamviewer/config \
      $out/share/teamviewer/tv_bin/{xdg-utils,RTlib} \
      $out/share/teamviewer/tv_bin/script/{teamviewer_setup,teamviewerd.sysv,teamviewerd.service,teamviewerd.*.conf,libdepend,tv-delayed-start.sh}

    ln -s $out/share/teamviewer/tv_bin/script/teamviewer $out/bin
    ln -s $out/share/teamviewer/tv_bin/teamviewerd $out/bin
    ln -s $out/share/teamviewer/tv_bin/desktop/teamviewer-teamviewer*.desktop $out/share/applications
    ln -s /var/lib/teamviewer $out/share/teamviewer/config
    ln -s /var/log/teamviewer $out/share/teamviewer/logfiles
    ln -s ${xdg_utils}/bin $out/share/teamviewer/tv_bin/xdg-utils

    pushd $out/share/teamviewer/tv_bin

    sed -i "s,TV_LD32_PATH=.*,TV_LD32_PATH=$(cat ${ld32})," script/tvw_config
    ${if stdenv.system == "x86_64-linux" then ''
      sed -i "s,TV_LD64_PATH=.*,TV_LD64_PATH=$(cat ${ld64})," script/tvw_config
    '' else ''
      sed -i "/TV_LD64_PATH=.*/d" script/tvw_config
    ''}

    sed -i "s,/opt/teamviewer,$out/share/teamviewer,g" desktop/teamviewer-*.desktop

    for i in teamviewer-config teamviewerd TeamViewer_Desktop TVGuiDelegate TVGuiSlave.32 wine/bin/*; do
      echo "patching $i"
      patchelf --set-interpreter $(cat ${ld32}) --set-rpath ${tvldpath32} $i || true
    done
    for i in resources/*.so wine/drive_c/TeamViewer/tvwine.dll.so wine/lib/*.so* wine/lib/wine/*.so; do
      echo "patching $i"
      patchelf --set-rpath ${tvldpath32} $i || true
    done
    ${if stdenv.system == "x86_64-linux" then ''
      patchelf --set-interpreter $(cat ${ld64}) --set-rpath ${tvldpath64} TVGuiSlave.64
    '' else ''
      rm TVGuiSlave.64
    ''}
    popd
  '';

  dontPatchELF = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = "http://www.teamviewer.com";
    license = licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ jagajaga ];
  };
}
