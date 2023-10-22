{ lib
, stdenv
, appimageTools
, requireFile
, unzip
, autoPatchelfHook
, openssl
, SDL2
, pulseaudio
, freetype
}:

stdenv.mkDerivation {
  pname = "minimeters";
  version = "0.8.8";

  src = requireFile {
    name = "MiniMeters-Linux-v0.8.8.zip";
    hash = "sha256-6Gi3Y1WWOyU5o/qwPTEV0MkbDnGm/n9P4GWQKM8v/iU=";
    url = ''https://directmusic.itch.io/minimeters (Legacy versions, extract "MiniMeters 0.8.8.zip")'';
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  sourceRoot = "."; # stdenv tries to go into the vst3 subfolder

  nativeBuildInputs = [ appimageTools.appimage-exec autoPatchelfHook unzip ];
  buildInputs = [ openssl SDL2 stdenv.cc.cc stdenv.cc.libc freetype ];

  # Technically ALSA is also supported but it runs *horribly*, so we force pulse:
  # The upstream distribution also ships PortAudio for some reason, but it doesn't
  # appear to be used on Linux.
  runtimeDependencies = [ pulseaudio ];

  postUnpack = ''
    # we cannot use appimageTools.extract because the propietary binary is a zip
    appimage-exec.sh -x extracted MiniMeters.AppImage
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin,lib/{clap,vst3}}
    cp -r extracted/usr/share/{icons,applications} $out/share
    cp extracted/usr/bin/MiniMeters $out/bin
    cp MiniMetersServer.clap $out/lib/clap || >&2 echo "clap plugin missing"
    cp -r MiniMetersServer.vst3 $out/lib/vst3

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple standalone audio metering app";
    homepage = "https://minimeters.app";
    changelog = "https://minimeters.app/changelog";
    license = licenses.unfree;
    maintainers = with maintainers; [ ckie ];
    # some darwin/windows builds are also available, but not packaged
    platforms = [ "x86_64-linux" ];
  };
}
