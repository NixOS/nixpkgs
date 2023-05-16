<<<<<<< HEAD
{ alsa-lib
, asio
, cmake
, curl
, fetchFromGitHub
, lib
, libremidi
=======
{ lib
, stdenv
, fetchFromGitHub
, asio
, cmake
, curl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, obs-studio
, opencv
, procps
, qtbase
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, websocketpp
, xorg
}:

stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
<<<<<<< HEAD
  version = "1.23.1";
=======
  version = "1.21.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-rpZ/vR9QbWgr8n6LDv6iTRsKXSIDGy0IpPu1Uatb0zw=";
=======
    sha256 = "1p6fl1fy39hrm7yasjhv6z79bnjk2ib3yg9dvf1ahwzkd9bpyfyl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
<<<<<<< HEAD
    alsa-lib
    asio
    curl
    libremidi
=======
    asio
    curl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    obs-studio
    opencv
    procps
    qtbase
    websocketpp
    xorg.libXScrnSaver
  ];

  dontWrapQtApps = true;

<<<<<<< HEAD
  postUnpack = ''
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
    chmod -R +w $sourceRoot/deps/libremidi
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = {
    description = "An automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    maintainers = with lib.maintainers; [ paveloom ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
