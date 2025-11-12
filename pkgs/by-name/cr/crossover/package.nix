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
  libxext,
  libxi,
  libxrandr,
  libxcursor,
  libsm,
  libice,
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
  version = "26.0.0";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover-${version}-1.rpm";
        hash = "sha256-R1oKKbTHkEBLEkwvJn2ygKR2su6yI2hgr6ZZ0cqpF7Y=";
      };
      aarch64-darwin = fetchzip {
        url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
        hash = "sha256-cIKX9dYSEuPaUjDl9AClgydxn7KwJMCaphs/73ac9I4=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Run your Windows® app on MacOS and Linux";
    homepage = "https://www.codeweavers.com/crossover";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; unfree;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      rpmextract
      autoPatchelfHook
      gobject-introspection
      wrapGAppsHook3
    ];

    buildInputs = [
      libxext
      libxi
      libxrandr
      libxcursor
      libsm
      libice
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
      rm -rf $out/lib64
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -R *.app $out/Applications
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
