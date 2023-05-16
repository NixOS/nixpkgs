{ buildPythonApplication
, lib
, fetchFromGitHub

  # build inputs
, atk
, file
, gdk-pixbuf
, glib-networking
, gnome-desktop
, gobject-introspection
, gst_all_1
, gtk3
, libnotify
, pango
, webkitgtk
, wrapGAppsHook

  # check inputs
, xvfb-run
, nose2
, flake8

  # python dependencies
, certifi
, dbus-python
, distro
, evdev
, lxml
, pillow
, pygobject3
, pypresence
, pyyaml
, requests
<<<<<<< HEAD
, protobuf
, moddb
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # commands that lutris needs
, xrandr
, pciutils
, psmisc
, glxinfo
, vulkan-tools
, xboxdrv
, pulseaudio
, p7zip
, xgamma
, libstrangle
, fluidsynth
, xorgserver
, xorg
, util-linux
}:

let
  # See lutris/util/linux.py
  requiredTools = [
    xrandr
    pciutils
    psmisc
    glxinfo
    vulkan-tools
    xboxdrv
    pulseaudio
    p7zip
    xgamma
    libstrangle
    fluidsynth
    xorgserver
    xorg.setxkbmap
    xorg.xkbcomp
    # bypass mount suid wrapper which does not work in fhsenv
    util-linux
  ];
in
buildPythonApplication rec {
  pname = "lutris-unwrapped";
<<<<<<< HEAD
  version = "0.5.13";
=======
  version = "0.5.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-ectrfbIkPhIqfhkavDpBCNdLPnGQhCnfFYwTf2IxB50=";
=======
    rev = "refs/tags/v${version}";
    sha256 = "sha256-rsiXm7L/M85ot6NrTyy//lMRFlLPJYve9y6Erg9Ugxg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
  buildInputs = [
    atk
    gdk-pixbuf
    glib-networking
    gnome-desktop
    gtk3
    libnotify
    pango
    webkitgtk
  ] ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  # See `install_requires` in https://github.com/lutris/lutris/blob/master/setup.py
  propagatedBuildInputs = [
    certifi
    dbus-python
    distro
    evdev
    lxml
    pillow
    pygobject3
    pypresence
    pyyaml
    requests
<<<<<<< HEAD
    protobuf
    moddb
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteInPlace lutris/util/magic.py \
      --replace "'libmagic.so.1'" "'${lib.getLib file}/lib/libmagic.so.1'"
  '';

  nativeCheckInputs = [ xvfb-run nose2 flake8 ] ++ requiredTools;
  checkPhase = ''
    runHook preCheck

    export HOME=$PWD
    xvfb-run -s '-screen 0 800x600x24' make test

    runHook postCheck
  '';

  # avoid double wrapping
  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath requiredTools}"
    "\${gappsWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "lutris";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
