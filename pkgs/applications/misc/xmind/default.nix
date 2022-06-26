{ lib,
  stdenv,
  fetchzip,
  gtk2,
  jre8,
  libXtst,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  runtimeShell,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "xmind";
  version = "8-update9";

  src = fetchzip {
    url = "https://xmind.net/xmind/downloads/${pname}-${version}-linux.zip";
    stripRoot = false;
    sha256 = "sha256-l2nEqdQtM3DtLC0b7VpdePH8PcW9YEsGS1YQH8f5C7Q=";
  };

  preferLocalBuild = true;

  patches = [ ./java-env-config-fixes.patch ];

  nativeBuildInputs = [ copyDesktopItems makeWrapper unzip ];

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  libPath = lib.makeLibraryPath [ gtk2 libXtst ];

  desktopItems = [
    (makeDesktopItem {
      name = "XMind";
      exec = "XMind";
      icon = "xmind";
      desktopName = "XMind";
      comment = meta.description;
      categories = [ "Office" ];
      mimeTypes = [ "application/xmind" "x-scheme-handler/xmind" ];
    })
  ];

  installPhase = let
    targetDir = if stdenv.hostPlatform.system == "i686-linux"
      then "XMind_i386"
      else "XMind_amd64";
  in ''
    runHook preInstall

    mkdir -p $out/{bin,libexec/configuration,share/fonts}
    cp -r ${targetDir}/{configuration,p2,XMind{,.ini}} $out/libexec
    cp -r {plugins,features} $out/libexec/
    cp -r fonts $out/share/fonts/

    for size in 16 32 48 64 128 256; do
      cathy=$(find plugins -name "org.xmind.cathy_*.jar" | head)
      out_dir=$out/share/icons/hicolor/"$size"x"$size"
      mkdir -p $out_dir
      unzip -j $cathy icons/xmind.$size.png -d $out_dir
      mv $out_dir/xmind.$size.png $out_dir/xmind.png
    done

    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      $out/libexec/XMind

    wrapProgram $out/libexec/XMind \
      --prefix LD_LIBRARY_PATH : "${libPath}"

    # Inspired by https://aur.archlinux.org/cgit/aur.git/tree/?h=xmind
    cat >$out/bin/XMind <<EOF
      #! ${runtimeShell}
      if [ ! -d "\$HOME/.xmind" ]; then
        mkdir -p "\$HOME/.xmind/configuration-cathy/"
        cp -r $out/libexec/configuration/ \$HOME/.xmind/configuration-cathy/
      fi

      exec "$out/libexec/XMind" "\$@"
    EOF
    chmod +x $out/bin/XMind

    ln -s ${jre8} $out/libexec/jre

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mind-mapping software";
    longDescription = ''
      XMind is a mind mapping and brainstorming software. In addition
      to the management elements, the software can capture ideas,
      clarify thinking, manage complex information, and promote team
      collaboration for higher productivity.

      It supports mind maps, fishbone diagrams, tree diagrams,
      organization charts, spreadsheets, etc. Normally, it is used for
      knowledge management, meeting minutes, task management, and
      GTD. Meanwhile, XMind can read FreeMind and MindManager files,
      and save to Evernote.
    '';
    homepage = "https://www.xmind.net/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
