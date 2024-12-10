{
  lib,
  mkDerivation,
  fetchurl,
  autoPatchelfHook,
  zstd,
  curl,
  ffmpeg,
  libjpeg_turbo,
  libpam-wrapper,
  libv4l,
  pulseaudio,
  zlib,
  xorg,
}:

mkDerivation rec {
  pname = "sky";
  version = "2.1.7801";

  src = fetchurl {
    url = "https://tel.red/repos/archlinux/sky-archlinux-${version}-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-3xiq2b3CwNjRd09q0z8olrmLGhgkJGAVkZoJSIHom+k=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    zstd
  ];

  buildInputs = [
    curl
    ffmpeg
    libjpeg_turbo
    libpam-wrapper
    libv4l
    pulseaudio
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXtst
    xorg.libXv
    xorg.libxkbfile
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv * $out/
    ln --force --symbolic $out/lib/sky/sky{,_sender} $out/bin
    substituteInPlace $out/share/applications/sky.desktop \
      --replace /usr/ $out/

    runHook postInstall
  '';

  meta = {
    description = "Lync & Skype for Business on Linux";
    homepage = "https://tel.red/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.wucke13 ];
    platforms = [ "x86_64-linux" ];
  };
}
