{ lib
, stdenv
, fetchFromGitLab
, cmake
, libxml2
, meson
, ninja
, perl
, python3
, pkgconf
, wrapGAppsHook
, at-spi2-core
, dbus
, elfutils
, epoxy
, gexiv2
, glib
, gobject-introspection
, gst-plugins-base
, gstreamer
, gtk3
, lcms2
, libdatrie
, libgphoto2
, libgudev
, libpeas
, libraw
, libselinux
, libsepol
, libthai
, libunwind
, libxkbcommon
, orc
, pcre
, udev
, util-linux
, xorg
}:

stdenv.mkDerivation rec {
  pname = "entangle";
  version = "3.0";

  src = fetchFromGitLab {
    owner = "entangle";
    repo = "entangle";
    rev = "v${version}";
    sha256 = "hz2WSDOjriQSavFlDT+35x1X5MeInq80ZrSP1WR/td0=";
  };

  nativeBuildInputs = [
    cmake
    glib.dev
    libxml2.bin # for xmllint
    meson
    ninja
    perl # for pod2man and build scripts
    python3 # for build scripts
    pkgconf
    wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    dbus
    epoxy
    elfutils
    gexiv2
    glib
    gobject-introspection
    gst-plugins-base
    gstreamer
    gtk3
    lcms2
    libdatrie
    libgphoto2
    libgudev
    libpeas
    libraw
    libselinux
    libsepol
    libthai
    libunwind
    libxkbcommon
    orc
    pcre
    udev
    util-linux
  ] ++ (with xorg; [
    libXdmcp
    libXtst
  ]);

  dontUseCmakeConfigure = true;

  # Disable building of doc/reference since it requires network connection to render XML to HTML
  # Patch build script shebangs
  postPatch = ''
    sed -i "/subdir('reference')/d" "docs/meson.build"
    patchShebangs --build build-aux meson_post_install.py
    sed -i meson_post_install.py \
      -e "/print('Update icon cache...')/d" \
      -e "/gtk-update-icon-cache/d"
  '';

  postInstall = ''
    substituteInPlace "$out/share/applications/org.entangle_photo.Manager.desktop" \
      --replace "Exec=entangle" "Exec=$out/bin/entangle"
  '';

  meta = with lib; {
    description = "Tethered camera control and capture";
    longDescription = ''
      Entangle uses GTK and libgphoto2 to provide a graphical interface
      for tethered photography with digital cameras.
      It includes control over camera shooting and configuration settings
      and 'hands off' shooting directly from the controlling computer.
      This app can also serve as a camera app for mobile devices.
    '';
    homepage = "https://gitlab.com/entangle/entangle";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
