{
  autoPatchelfHook,
  desktop-file-utils,
  fetchurl,
  fetchzip,
  freetype,
  gobject-introspection,
  gtk3,
  lcms2,
  lib,
  libGLU,
  libpng,
  python3,
  rpmextract,
  stdenv,
  vte,
  wrapGAppsHook3,
  xorg,
  libgphoto2,
  libunwind,
  ocl-icd,
  sane-backends,
  alsa-lib,
  gst_all_1,
  libpulseaudio,
  libusb1,
  zlib,
}:

let
  pname = "crossover";
  version_mac = "25.1.1";
  version_linux = "25.1.0";

  src = rec {
      x86_64-linux = fetchurl {
        url = "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover-${version_linux}-1.rpm";
        hash = "sha256-RJrHiaRulLmlveNnme6v4ZwrRpXiZ6MrVcNu7EPFdEM=";
      };
      x86_64-darwin = fetchzip {
        url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version_mac}.zip";
        hash = "sha256-AI9Whjf1vyAKP9sinYqvOzbryXdyeHTbFxgHN5jqWbg=";
      };
      aarch64-darwin = x86_64-darwin;
    }
    .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Run your Windows® app on MacOS and Linux";
    homepage = "https://www.codeweavers.com/crossover";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; unfree;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      src
      meta
      ;

    version = version_linux;

    nativeBuildInputs = [
      rpmextract
      autoPatchelfHook
      gobject-introspection
      wrapGAppsHook3
    ];

    buildInputs =
      (with xorg; [
        libXext
        libXi
        libXrandr
        libXcursor
        libSM
        libICE
      ])
      ++ [
        gtk3
        freetype
        libGLU
        zlib
        libpng
        lcms2
        libgphoto2
        libunwind
        ocl-icd
        sane-backends
        alsa-lib
        gst_all_1.gst-plugins-base
        libpulseaudio
        libusb1
      ];

    autoPatchelfIgnoreMissingDeps = [
      "libcapi20.so.3"
      "libpcsclite.so.1"
      "libpcap.so.0.8"
    ];

    unpackPhase = ''
      rpmextract $src
    '';

    installPhase = ''
      mkdir -pv $out
      cp -R ./opt/cxoffice/* $out/
      mv $out/lib64/* $out/lib
      rm -rf $out/lib64
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      src
      meta
      ;

    version = version_mac;

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -R *.app $out/Applications
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
