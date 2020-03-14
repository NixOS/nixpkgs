{ stdenv
, fetchFromGitHub
, bash
, cairo
, glib
, gnome3
, gobject-introspection
, gstreamer
, gtk3
, libcanberra-gtk3
, pkgconfig
, wrapGAppsHook
, setproctitle
, distro
, pygobject3
, buildPythonApplication
, openrazer
, openrazer-daemon
, requests
, hicolor-icon-theme
, gdk-pixbuf
, imagemagick
, desktop-file-utils
, ninja
, webkitgtk
, meson
, sass
, sassc
, ibus
}:

  buildPythonApplication rec {
    name = "polychromatic-${version}";
    version = "unstable-2020-03-10";

    format = "other";

    src = fetchFromGitHub {
      owner = "polychromatic";
      repo = "polychromatic";
      rev = "5ca66b65c6d739e20c973b76a74054476e9c8cce";
      sha256 = "1xvdpf7h148jgf0q7bh6fhzgvwxdfx2kav7w3kj1x9sxpkza72a1";
    };

    pathsToLink = [ "/bin" "/etc" "/lib" "/share" ];

    buildInputs = [
      cairo
      hicolor-icon-theme
    ];

    propagatedBuildInputs = [
      setproctitle
      openrazer
      openrazer-daemon
      requests
      ibus
    ];

    nativePropagatedBuildInputs = [
      gobject-introspection
      gtk3
      gdk-pixbuf
      imagemagick
    ];

    nativeBuildInputs = [
      desktop-file-utils
      gobject-introspection
      wrapGAppsHook
      webkitgtk
      gnome3.librsvg
      sass
      sassc
      ninja
      meson
    ];

  postInstall = ''
    patchShebangsAuto $out/lib/python3.7/site-packages/polychromatic
    install -Dm755 $src/polychromatic-cli $out/bin
    for file in $(find $out/lib/python3.7/site-packages/polychromatic -type f \( -name \*.py\* \) ); do
      substituteInPlace $file --replace /usr/share $out/share
      substituteInPlace $file --replace /usr/bin $out/bin
      substituteInPlace $file --replace /usr/lib $out/lib
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://polychromatic.app/";
    description = "Graphical front-end and tray applet for configuring Razer peripherals on GNU/Linux.";
    longDescription = ''
      Polychromatic is a frontend for OpenRazer that enables Razer devices
      to control lighting effects and more on GNU/Linux.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evanjs ];
  };
}
