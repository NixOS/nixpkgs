{ lib
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, qttools
, gstreamer
, libX11
, pulseaudio
, qtbase
, qtmultimedia
, qtx11extras

, gst-plugins-base
, gst-plugins-good
, gst-plugins-bad
, gst-plugins-ugly
, wayland
, pipewire
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "vokoscreen-ng";
<<<<<<< HEAD
  version = "3.7.0";
=======
  version = "3.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-epz/KoXo84zzCD1dzclRWgeQSqrgwEtaIGvrTPuN9hw=";
=======
    sha256 = "sha256-Du/Dq7AUH5CeEKYr0kxcqguAyRVI5Ame41nU3FGvG+U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [ qttools pkg-config qmake wrapQtAppsHook ];
  buildInputs = [
    gstreamer
    libX11
    pulseaudio
    qtbase
    qtmultimedia
    qtx11extras
    wayland
    pipewire
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  postPatch = ''
    substituteInPlace src/vokoscreenNG.pro \
      --replace lrelease-qt5 lrelease
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons
    cp ./vokoscreenNG $out/bin/
    cp ./src/applications/vokoscreenNG.desktop $out/share/applications/
    cp ./src/applications/vokoscreenNG.png $out/share/icons/
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
    wrapQtApp $out/bin/vokoscreenNG
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
