{ stdenv
, fetchurl
, dbus
, zlib, fontconfig
, qtbase, qtmultimedia
, libjson, libgpgerror
, libX11, libxcb, libXau, libXdmcp, freetype, libbsd
, pythonPackages, squashfsTools, desktop-file-utils
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

in stdenv.mkDerivation rec {

  pname = "soulseekqt";
  inherit version;
  src = srcs."${stdenv.hostPlatform.system}" or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  dontBuild = true;

  buildInputs = [ pythonPackages.binwalk squashfsTools desktop-file-utils ];

  # avoid usage of appimage's runner option --appimage-extract 
  unpackCmd = ''
    export HOME=$(pwd) # workaround for binwalk
    appimage=$(tar xvf $curSrc) && binwalk --quiet \
       $appimage -D 'squashfs:squashfs:unsquashfs %e'
    '';
  
  patchPhase = ''
    cd squashfs-root/
    binary="$(readlink AppRun)"
  
    # fixup desktop file
    desktop-file-edit --set-key Exec --set-value $binary default.desktop
    desktop-file-edit --set-key Comment --set-value "${meta.description}" default.desktop
    desktop-file-edit --set-key Categories --set-value Network default.desktop   
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/applications,share/icons/}
    cp default.desktop $out/share/applications/$binary.desktop
    cp soulseek.png $out/share/icons/
    cp $binary $out/bin/
  '';

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${libPath} \
             $out/bin/$binary
  '';

  meta = with stdenv.lib; {
    description = "Official Qt SoulSeek client";
    homepage = http://www.soulseekqt.net;
    license = licenses.unfree;
    maintainers = [ maintainers.genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
