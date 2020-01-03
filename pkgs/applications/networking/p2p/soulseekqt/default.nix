{ stdenv, lib, fetchurl, mkDerivation
, autoPatchelfHook
, dbus
, desktop-file-utils
, fontconfig
, libjson
, pythonPackages
, qtmultimedia
, squashfsTools
, zlib
}:

mkDerivation rec {
  pname = "soulseekqt";
  version = "2018-1-30";

  src = fetchurl {
      urls = [
        "https://www.dropbox.com/s/0vi87eef3ooh7iy/SoulseekQt-${version}.tgz"
        "https://www.slsknet.org/SoulseekQt/Linux/SoulseekQt-${version}-64bit-appimage.tgz"
      ];
      sha256 = "0d1cayxr1a4j19bc5a3qp9pg22ggzmd55b6f5av3lc6lvwqqg4w6";
    };

  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook pythonPackages.binwalk squashfsTools desktop-file-utils ];
  buildInputs = [ qtmultimedia stdenv.cc.cc ];

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

  meta = with lib; {
    description = "Official Qt SoulSeek client";
    homepage = http://www.soulseekqt.net;
    license = licenses.unfree;
    maintainers = [ maintainers.genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
