{ stdenv
, lib
, dpkg
, fetchurl
, autoPatchelfHook
, webkitgtk
, libappindicator
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  name = "dorion";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/SpikeHD/Dorion/releases/download/v${version}/dorion_${version}_amd64.deb";
    sha256 = "sha256-RKqu+aNLCbjH+802PCboiayYqGlTTOJDjzHaAMyIbj8=";
  };

  runtimeDependencies = [ libappindicator libayatana-appindicator ];

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    mv usr $out
  '';

  meta = with lib; {
    description = "Tiny alternative Discord client with a smaller footprint, themes and plugins, multi-profile, and more!";
    homepage = "https://github.com/SpikeHD/Dorion";
    maintainers = [ maintainers.nyanbinary ];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    mainProgram = "dorion";
  };
}
