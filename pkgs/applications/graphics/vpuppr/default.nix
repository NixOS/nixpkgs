{ lib
, stdenv
, alsa-lib
, gcc-unwrapped
, git
, libGLU
, libglvnd
, libpulseaudio
, perl
, zlib
, udev
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, fetchzip
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, fetchurl
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "vpuppr";
  version = "0.9.0";

  src = fetchzip {
    url = "https://github.com/virtual-puppet-project/vpuppr/releases/download/${version}/vpuppr_${version}_linux.zip";
    hash = "sha256-JKiVM1N/NOa5StqUG+BV7ZvNZmDfi5jNKaeWJLy/pTA=";
  };

  icon = fetchurl {
    url = "https://github.com/virtual-puppet-project/vpuppr/raw/${version}/assets/osfgd_icon.png";
    hash = "sha256-2SdiUCfHLhbMKzpfyulp/qDGShNwCvMXotkBH0I7VDM=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "Virtual Puppet Project";
      desktopName = "Virtual Puppet Project";
      comment = "VTuber application made with Godot 3.5";
      exec = "vpuppr";
      icon = "vpuppr_icon";
      categories = [ "Graphics" "AudioVideo" "Recorder" ];
      terminal = false;
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libglvnd
    libpulseaudio
    perl
    zlib
    udev
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
  ];

  installPhase = ''
    runHook preInstall

    # vpuppr requires its resources to be in the same directory as the executable
    # hence we place everything in share first and symlink the executable to bin

    mkdir -p $out/share/vpuppr
    cp -r resources $out/share/vpuppr/
    cp vpuppr.pck $out/share/vpuppr/
    install -Dm555 vpuppr.x86_64 $out/share/vpuppr/vpuppr.x86_64

    mkdir -p $out/bin
    ln -s $out/share/vpuppr/vpuppr.x86_64 $out/bin/vpuppr

    wrapProgram $out/bin/vpuppr \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

    mkdir -p $out/share/icons
    cp ${icon} $out/share/icons/vpuppr_icon.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "VTuber application made with Godot 3.5";
    homepage = "https://github.com/virtual-puppet-project/vpuppr";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jonboylecoding ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };

}
