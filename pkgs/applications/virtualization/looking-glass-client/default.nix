{ stdenv, lib, fetchurl, makeDesktopItem, cmake, pkg-config
, freefont_ttf, spice-protocol, nettle, libbfd, fontconfig, libffi, expat
, libxkbcommon, libGL, libXext, libXrandr, libXi, libXScrnSaver, libXinerama
, libXcursor, libXpresent, wayland, wayland-protocols
}:

let
  desktopItem = makeDesktopItem {
    name = "looking-glass-client";
    desktopName = "Looking Glass Client";
    type = "Application";
    exec = "looking-glass-client";
    icon = "lg-logo";
    terminal = true;
  };
in
stdenv.mkDerivation rec {
  pname = "looking-glass-client";
  version = "B5.0.1";

  src = fetchurl {
    url = "https://looking-glass.io/artifact/${version}/source";
    sha256 = "sha256-9gVoWkNV67zeBotC5q19QFISEOuPa5XMyioiS/qJNt0=";
    name = "looking-glass-${version}-source.tar.gz";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    freefont_ttf
    spice-protocol
    expat
    libbfd
    nettle
    fontconfig
    libffi
    libxkbcommon
    libXi
    libXScrnSaver
    libXinerama
    libXcursor
    libXpresent
    libXext
    libXrandr
    wayland
    wayland-protocols
  ];

  cmakeFlags = [ "-DOPTIMIZE_FOR_NATIVE=OFF" ];

  setSourceRoot = ''
    export sourceRoot=$(realpath */client)
  '';

  preConfigure = ''
    if [[ ! -f ../VERSION ]]; then
      echo 'Missing VERSION file'
      exit 1
    fi
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s ${desktopItem}/share/applications $out/share/
    cp ../../resources/lg-logo.png $out/share/pixmaps
  '';

  meta = with lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
