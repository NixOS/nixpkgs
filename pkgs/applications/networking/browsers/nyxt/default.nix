{ lib
, stdenv
, cairo
, enchant
, gdk-pixbuf
, glib
, glib-networking
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, gst_all_1
, lispPackages
, mime-types
, pango
, wrapGAppsHook
, xclip
}:

stdenv.mkDerivation rec {
  pname = "nyxt";
  inherit (lispPackages.nyxt.meta) version;

  src = lispPackages.nyxt;

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [
    cairo
    enchant
    gdk-pixbuf
    glib
    glib-networking
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    mime-types
    pango
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  binPath = lib.optionals (!stdenv.isDarwin) [ xclip ];

  doInstallCheck = !stdenv.isDarwin;
  dontBuild = true;
  dontWrapGApps = true;

  # stripping breaks the Linux build, possibly because the resulting binary is
  # already stripped once in lispPackages.nyxt
  dontStrip = true;

  installPhase = ''
      runHook preInstall
    '' + (if stdenv.isDarwin then ''
      mkdir -p $out/bin $out/Applications/Nyxt.app/Contents
      pushd $out/Applications/Nyxt.app/Contents
      install -Dm644 $src/lib/common-lisp/nyxt/assets/Info.plist Info.plist
      install -Dm644 $src/lib/common-lisp/nyxt/assets/nyxt.icns Resources/nyxt.icns
      install -Dm755 $src/bin/nyxt MacOS/nyxt
      popd

      gappsWrapperArgsHook # FIXME: currently runs at preFixup
      wrapGApp $out/Applications/Nyxt.app/Contents/MacOS/nyxt \
        --prefix PATH : "${lib.makeBinPath binPath}" \
        --argv0 nyxt

      ln -s $out/Applications/Nyxt.app/Contents/MacOS/nyxt $out/bin/nyxt
    '' else ''
      mkdir -p $out/share/applications/
      sed "s/VERSION/$version/" $src/lib/common-lisp/nyxt/assets/nyxt.desktop > $out/share/applications/nyxt.desktop
      for i in 16 32 128 256 512; do
        mkdir -p "$out/share/icons/hicolor/''${i}x''${i}/apps/"
        cp -f $src/lib/common-lisp/nyxt/assets/nyxt_''${i}x''${i}.png "$out/share/icons/hicolor/''${i}x''${i}/apps/nyxt.png"
      done

      install -Dm755 $src/bin/nyxt $out/bin/nyxt

      gappsWrapperArgsHook # FIXME: currently runs at preFixup
      wrapGApp $out/bin/nyxt \
        --prefix PATH : "${lib.makeBinPath binPath}" \
        --argv0 nyxt
    '') + ''
      runHook postInstall
    '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/nyxt -h
    runHook postCheck
  '';

  meta = with lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    homepage = "https://nyxt.atlas.engineer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lewo payas ];
    platforms = platforms.all;
  };
}
