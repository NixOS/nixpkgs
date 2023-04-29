{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, xorg
, curl
, procps
, libxkbcommon
, libxkbfile
, obs-studio
, pkg-config
, opencv
, websocketpp
, asio
}:

stdenv.mkDerivation rec {
  pname = "obs-scale-to-sound";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "obs-scale-to-sound";
    rev = version;
    sha256 = "04k7f7v756vdsan95g73cc29lrs61jis738v37a3ihi3ivps3ma3";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    obs-studio qtbase xorg.libX11 xorg.libXau xorg.libXdmcp xorg.libXtst xorg.libXext
    xorg.libXi xorg.libXt xorg.libXinerama xorg.libXScrnSaver procps curl opencv websocketpp asio libxkbcommon libxkbfile
  ];
  dontWrapQtApps = true;

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = {
    description = "A plugin for OBS Studio that adds a filter which makes a source scale based on the audio levels of any audio source you choose";
    homepage = "https://github.com/dimtpap/obs-scale-to-sound";
    maintainers = with lib.maintainers; [ takov751 ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
