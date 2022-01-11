{ lib, stdenv, fetchurl, makeWrapper, makeDesktopItem, wrapGAppsHook, gtk3, gsettings-desktop-schemas
, zlib , libX11, libXext, libXi, libXrender, libXtst, libGL, alsa-lib, cairo, freetype, pango, gdk-pixbuf, glib }:

stdenv.mkDerivation rec {
  version = "5.1";
  pname = "jabref";

  src = fetchurl {
    url = "https://github.com/JabRef/jabref/releases/download/v${version}/JabRef-${version}-portable_linux.tar.gz";
    sha256 = "04f612byrq3agzy26byg1sgrjyhcpa8xfj0ssh8dl8d8vnhx9742";
  };

  preferLocalBuild = true;

  desktopItem = makeDesktopItem {
    comment =  meta.description;
    name = "jabref";
    desktopName = "JabRef";
    genericName = "Bibliography manager";
    categories = "Office;";
    icon = "jabref";
    exec = "jabref";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ gsettings-desktop-schemas ] ++ systemLibs;

  systemLibs = [ gtk3 zlib libX11 libXext libXi libXrender libXtst libGL alsa-lib cairo freetype pango gdk-pixbuf glib ];
  systemLibPaths = lib.makeLibraryPath systemLibs;

  installPhase = ''
    mkdir -p $out/share/java $out/share/icons

    cp -r lib $out/lib

    for f in $out/lib/runtime/bin/j*; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${ lib.makeLibraryPath [ zlib ]}:$out/lib/runtime/lib:$out/lib/runtime/lib/server" $f
    done

    for f in $out/lib/runtime/lib/*.so; do
      patchelf \
        --set-rpath "${systemLibPaths}:$out/lib/runtime/lib:$out/lib/runtime/lib/server" $f
    done

    # patching the libs in the JImage runtime image is quite impossible as there is no documented way
    # of rebuilding the image after it has been extracted
    # the image format itself is "intendedly not documented" - maybe one of the reasons the
    # devolpers constantly broke "jimage recreate" and dropped it in OpenJDK 9 Build 116 Early Access
    # so, for now just copy the image and provide our lib paths through the wrapper

    makeWrapper $out/lib/runtime/bin/java $out/bin/jabref \
      --add-flags '-Djava.library.path=${systemLibPaths}' --add-flags "-p $out/lib/app -m org.jabref/org.jabref.JabRefLauncher" \
      --prefix LD_LIBRARY_PATH : '${systemLibPaths}'

    cp -r ${desktopItem}/share/applications $out/share/

    # we still need to unpack the runtime image to get the icon
    mkdir unpacked
    $out/lib/runtime/bin/jimage extract --dir=./unpacked lib/runtime/lib/modules
    cp unpacked/org.jabref/icons/jabref.svg $out/share/icons/jabref.svg
  '';

  meta = with lib; {
    description = "Open source bibliography reference manager";
    homepage = "https://www.jabref.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
