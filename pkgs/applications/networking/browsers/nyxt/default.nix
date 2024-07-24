{ stdenv, lib, sbclPackages
, makeWrapper, wrapGAppsHook3, gst_all_1
, glib, gdk-pixbuf, cairo
, mailcap, pango, gtk3
, glib-networking, gsettings-desktop-schemas
, xclip, wl-clipboard, notify-osd, enchant
}:

stdenv.mkDerivation rec {
  pname = "nyxt";
  inherit (sbclPackages.nyxt) version;

  src = sbclPackages.nyxt;

  nativeBuildInputs = [ makeWrapper wrapGAppsHook3 ];
  gstBuildInputs = with gst_all_1; [
    gstreamer gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];
  buildInputs = [
    glib gdk-pixbuf cairo
    mailcap pango gtk3
    glib-networking gsettings-desktop-schemas
    notify-osd enchant
  ] ++ gstBuildInputs;

  GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstBuildInputs;

  # The executable is already built in sbclPackages.nyxt, buildPhase tries to build using the makefile which we ignore
  dontBuild = true;

  dontWrapGApps = true;
  installPhase = ''
    mkdir -p $out/share/applications/
    sed "s/VERSION/$version/" $src/assets/nyxt.desktop > $out/share/applications/nyxt.desktop
    for i in 16 32 128 256 512; do
      mkdir -p "$out/share/icons/hicolor/''${i}x''${i}/apps/"
      cp -f $src/assets/nyxt_''${i}x''${i}.png "$out/share/icons/hicolor/''${i}x''${i}/apps/nyxt.png"
    done

    mkdir -p $out/bin && makeWrapper $src/bin/nyxt $out/bin/nyxt \
      --prefix PATH : ${lib.makeBinPath [ xclip wl-clipboard ]} \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${GST_PLUGIN_SYSTEM_PATH_1_0}" \
      --argv0 nyxt "''${gappsWrapperArgs[@]}"
  '';

  checkPhase = ''
    $out/bin/nyxt -h
  '';

  meta = with lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lewo dariof4 ];
    platforms = platforms.all;
  };
}
