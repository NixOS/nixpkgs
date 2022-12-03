{ stdenv
, dpkg
, glibc
, gcc-unwrapped
, autoPatchelfHook
, fetchurl
, lib
, zlib
, tree
# , qtbase
# , wrapQtAppsHook

# from pkgs/development/libraries/qt-5/modules/qtbase.nix
, dbus, glib, udev

, libX11, libXcomposite, libXext, libXi, libXrender, libxcb, libxkbcommon, xcbutil
, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm

, libGL
, gst_all_1
, libXfixes, libusb1, bluez
}:

let

  version = "1.5.1";

  src = if stdenv.hostPlatform.system == "x86_64-linux" then fetchurl {
    url = "https://github.com/neuromore/studio/releases/download/1.5.1/Studio.deb";
    sha256 = "038yp2lccw0qy8v53vd6mq9aj81wrif9lzsqgr9f22d6yc8s5r5p";
  } else throw "TODO";

in stdenv.mkDerivation {
  name = "neuromore-${version}";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    # wrapQtAppsHook
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
    # tree
  ];

  # Required at running time
  buildInputs = [
    # qtbase
    # glibc
    gcc-unwrapped

    # X11 libs
    libX11 libXcomposite libXext libXi libXrender libxcb libxkbcommon xcbutil
    xcbutilimage xcbutilkeysyms xcbutilrenderutil xcbutilwm

    dbus glib udev

    libGL

    libXfixes libusb1 bluez
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav gst-plugins-bad ]);

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir $out
    dpkg -x $src $out

    mkdir $out/bin
    mv $out/usr/local/bin/Studio $out/bin/neuromore
    rm -rfd $out/usr
  '';

  meta = with lib; {
    description = "Neuromore";
    homepage = "https://github.com/neuromore/studio";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ srghma ];
    platforms = [ "x86_64-linux" ];
  };
}
