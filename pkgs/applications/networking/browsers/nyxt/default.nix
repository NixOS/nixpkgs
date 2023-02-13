{ stdenv, lib, lispPackages
, makeWrapper, wrapGAppsHook, gst_all_1
, glib, gdk-pixbuf, cairo
, mailcap, pango, gtk3
, glib-networking, gsettings-desktop-schemas
, xclip, notify-osd, enchant
}:

stdenv.mkDerivation rec {
  pname = "nyxt";
  inherit (lispPackages.nyxt.meta) version;

  src = lispPackages.nyxt;

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
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
    xclip notify-osd enchant
  ] ++ gstBuildInputs;

  GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstBuildInputs;

  dontWrapGApps = true;
  installPhase = ''
    mkdir -p $out/share/applications/
    sed "s/VERSION/$version/" $src/lib/common-lisp/nyxt/assets/nyxt.desktop > $out/share/applications/nyxt.desktop
    for i in 16 32 128 256 512; do
      mkdir -p "$out/share/icons/hicolor/''${i}x''${i}/apps/"
      cp -f $src/lib/common-lisp/nyxt/assets/nyxt_''${i}x''${i}.png "$out/share/icons/hicolor/''${i}x''${i}/apps/nyxt.png"
    done

    mkdir -p $out/bin && makeWrapper $src/bin/nyxt $out/bin/nyxt \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${GST_PLUGIN_SYSTEM_PATH_1_0}" \
      --argv0 nyxt "''${gappsWrapperArgs[@]}"
  '';

  checkPhase = ''
    $out/bin/nyxt -h
  '';

  meta = with lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    homepage = "https://nyxt.atlas.engineer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lewo payas ];
    platforms = platforms.all;
  };
}
