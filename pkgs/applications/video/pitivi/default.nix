{ stdenv
, fetchFromGitHub
, fetchurl
, fetchpatch
, pkg-config
, gettext
, itstool
, python3
, wrapGAppsHook
, python3Packages
, gst_all_1
, gtk3
, gobject-introspection
, librsvg
, gnome3
, libnotify
, gsound
, meson
, ninja
, gsettings-desktop-schemas
}:

let
  # gst-transcoder was merged with gst-plugins-bad 1.18.
  # TODO: switch to that once available.
  gst-transcoder = stdenv.mkDerivation rec {
    version = "1.14.1";
    pname = "gst-transcoder";
    src = fetchFromGitHub {
      owner = "pitivi";
      repo = "gst-transcoder";
      rev = version;
      sha256 = "16skiz9akavssii529v9nr8zd54w43livc14khdyzv164djg9q8f";
    };
    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      gobject-introspection
      python3
    ];
    buildInputs = with gst_all_1; [
      gstreamer
      gst-plugins-base
    ];
  };

in python3Packages.buildPythonApplication rec {
  pname = "pitivi";
  version = "0.999";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pitivi/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mxp2p4gg976fp1vj3rb5rmpl5mqfzncm9vw2719irl32f1qlvyb";
  };

  patches = [
    # By default, the build picks up environment variables like PYTHONPATH
    # and saves them to the generated binary. This would make the build-time
    # dependencies part of the closure so we remove it.
    ./prevent-closure-contamination.patch

    # Port from intltool to gettext.
    # Needed for the following patches to apply.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/pitivi/commit/89b1053f2516c594f414c5c67c835471bce44b67.patch";
      sha256 = "8yhArzAtZC+WjHftcSDrstBlT8j6WlGHffU9Nj+ny+c=";
      excludes = [ "po/POTFILES.in" ];
    })

    # Complete switching to gst-transcoder in gst-plugins-bad.
    # Otherwise there will likely be conflics.
    # TODO: Apply this patch once we are using gst-transcoder from gst-plugins-bad.
    # (fetchpatch {
    #   url = "https://gitlab.gnome.org/GNOME/pitivi/commit/51ae6533ee26ffd47e453eb5f5ad8cd46f57d15e.patch";
    #   sha256 = "zxJm+E5o+oZ3lW6wYNY/ERo2g4NmCjoY8oV+uScq8j8=";
    # })

    # Generate renderer.so on macOS instead of dylib.
    # Needed for the following patch to apply.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/pitivi/commit/bcacadcafabf8911efb0fddc8d57329237d08cd1.patch";
      sha256 = "2BM5acIwOgdr1L9vhtMMN4trrLuqCg/K6v6ZYtD1Fjw=";
      postFetch = ''
        sed -i -e "s/1.90.0.1/0.999/g" "$out"
      '';
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/pitivi/commit/0a3cc054a2c20b59f5aaaaa307de3c9af3c0d270.patch";
      sha256 = "6DhqRlxFWFFdLwGoFem+vPt8x7v732KMVjMF9fypMK4=";
      postFetch = ''
        sed "$out" -i \
          -e "s/1.90.0.1/0.999/g" \
          -e "s/\(-python_dep.*\)/\1\n /" \
          -e "s/-1,9 +1,16/-1,10 +1,17/"
      '';
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    librsvg
    gnome3.gnome-desktop
    gsound
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
    libnotify
    gst-transcoder
  ] ++ (with gst_all_1; [
    gstreamer
    gst-editing-services
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    gst-validate
  ]);

  pythonPath = with python3Packages; [
    pygobject3
    gst-python
    pyxdg
    numpy
    pycairo
    matplotlib
    dbus-python
  ];

  postPatch = ''
    patchShebangs ./getenvvar.py

    # fetchpatch does not support renamings
    mv data/org.pitivi.Pitivi-mime.xml data/org.pitivi.Pitivi-mime.xml.in
  '';

  # Fixes error
  #     Couldn’t recognize the image file format for file ".../share/pitivi/pixmaps/asset-proxied.svg"
  # at startup, see https://github.com/NixOS/nixpkgs/issues/56943
  # and https://github.com/NixOS/nixpkgs/issues/89691#issuecomment-714398705.
  strictDeps = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "pitivi";
      versionPolicy = "none"; # we are using dev version, since the stable one is too old
    };
  };

  meta = with stdenv.lib; {
    description = "Non-Linear video editor utilizing the power of GStreamer";
    homepage = "http://pitivi.org/";
    longDescription = ''
      Pitivi is a video editor built upon the GStreamer Editing Services.
      It aims to be an intuitive and flexible application
      that can appeal to newbies and professionals alike.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
