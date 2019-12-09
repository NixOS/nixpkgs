{ stdenv, lib, fetchzip, mkDerivation
, autoPatchelfHook
, dbus
, desktop-file-utils
, fontconfig
, imagemagick
, libjson
, qtmultimedia
, radare2
, jq
, squashfsTools
, zlib
}:

mkDerivation rec {
  pname = "soulseekqt";
  version = "2018-1-30";

  src = fetchzip {
      url = "https://www.slsknet.org/SoulseekQt/Linux/SoulseekQt-${version}-64bit-appimage.tgz";
      sha256 = "16ncnvv8h33f161mgy7qc0wjvvqahsbwvby65qhgfh9pbbgb4xgg";
    };

  dontBuild = true;

  nativeBuildInputs = [ imagemagick radare2 jq autoPatchelfHook squashfsTools
    desktop-file-utils ];
  buildInputs = [ qtmultimedia stdenv.cc.cc ];

  # avoid usage of appimage's runner option --appimage-extract
  postUnpack = ''
    cd $sourceRoot

    # multiarch offset one-liner using same method as AppImage
    offset=$(r2 *.AppImage -nn -Nqc "pfj.elf_header @ 0" |\
      jq 'map({(.name): .value}) | add | .shoff + (.shnum * .shentsize)')

    unsquashfs -o $offset *.AppImage
    sourceRoot=squashfs-root
  '';

  installPhase = ''

      binary="$(readlink AppRun)"
      mv default.desktop $binary.desktop
      install -Dm755 $binary -t $out/bin

      # fixup and install desktop file
      desktop-file-install --dir $out/share/applications \
        --set-key Exec --set-value $binary \
        --set-key Comment --set-value "${meta.description}" \
        --set-key Categories --set-value Network $binary.desktop

      #TODO: write generic code to read icon path from $binary.desktop
      for size in 16 32 48 64 72 96 128 192 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        convert -resize "$size"x"$size" ./soulseek.png $out/share/icons/hicolor/"$size"x"$size"/apps/soulseek.png
      done
    '';

  meta = with lib; {
    description = "Official Qt SoulSeek client";
    homepage = https://www.slsknet.org;
    license = licenses.unfree;
    maintainers = [ maintainers.genesis ];
    platforms = [ "x86_64-linux" ];
  };
}
