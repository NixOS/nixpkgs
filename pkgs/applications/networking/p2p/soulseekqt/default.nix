{ stdenv
, fetchurl
, dbus
, zlib, fontconfig
, qtbase, qtmultimedia
, libjson, libgpgerror
, libX11, libxcb, libXau, libXdmcp, freetype, libbsd
, pythonPackages, squashfsTools, makeDesktopItem
}:

with stdenv.lib;
let
  libPath = makeLibraryPath
    [ stdenv.cc.cc qtbase qtmultimedia dbus libX11 zlib libX11 libxcb libXau libXdmcp freetype fontconfig libbsd libjson libgpgerror];

  version = "2018-1-30";

  mainbin = "SoulseekQt-" + (version) +"-"+ (if stdenv.is64bit then "64bit" else "32bit");
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://www.dropbox.com/s/0vi87eef3ooh7iy/${mainbin}.tgz";
      sha256 = "0d1cayxr1a4j19bc5a3qp9pg22ggzmd55b6f5av3lc6lvwqqg4w6";
    };
  };

  desktopItem = makeDesktopItem {
    name = "SoulseekQt";
    exec = "soulseekqt";
    icon = "$out/share/soulseekqt/";
    comment = "Official Qt SoulSeek client"; 
    desktopName = "SoulseekQt";
    genericName = "SoulseekQt";
    categories = "Network;";
  };

in stdenv.mkDerivation rec {

  name = "soulseekqt-${version}";
  inherit version;
  src = srcs."${stdenv.hostPlatform.system}" or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  dontBuild = true;

  buildInputs = [ pythonPackages.binwalk squashfsTools ];

  # avoid usage of appimagetool
  unpackCmd = ''
    export HOME=$(pwd) # workaround for binwalk
    tar xvf $curSrc && binwalk --quiet \
       ${mainbin}.AppImage -D 'squashfs:.squashfs:unsquashfs %e'
    '';

  installPhase = ''
    mkdir -p $out/{bin,share/soulseekqt}
    cd squashfs-root/
    cp -R soulseek.png translations $out/share/soulseekqt
    cp SoulseekQt $out/bin/soulseekqt
  '';

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${libPath} \
             $out/bin/soulseekqt
  '';

  meta = with stdenv.lib; {
    description = "Official Qt SoulSeek client";
    homepage = http://www.soulseekqt.net;
    license = licenses.unfree;
    maintainers = [ maintainers.genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
