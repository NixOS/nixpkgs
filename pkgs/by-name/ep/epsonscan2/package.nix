{
  lib,
  stdenv,
  autoPatchelfHook,
  boost186,
  cmake,
  copyDesktopItems,
  imagemagick,
  fetchpatch,
  fetchzip,
  killall,
  libjpeg,
  libpng,
  libtiff,
  libtool,
  libusb1,
  makeDesktopItem,
  qt5,

  withGui ? true,
  withNonFreePlugins ? false,
}:

let
  pname = "epsonscan2";
  description = "Epson Scan 2 scanner driver for many modern Epson scanners and multifunction printers";
  # Epson updates projects without changing their version numbers.
  # There can be multiple different packages identified by the same
  #version, so we also tag them with the month and year shown in
  # the Epson download page.
  version = "6.7.70.0-01-2025";

  system = stdenv.hostPlatform.system;

  src = fetchzip {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/16/60/70/c7fc14e41ec84255008c6125b63bcac40f55e11c/epsonscan2-6.7.70.0-1.src.tar.gz";
    hash = "sha256-WvNBy5hAxNJfwgjBR5VGaXuyTCK2YEiD3i7SMDl3U/U=";
  };
  bundle =
    {
      "x86_64-linux" = fetchzip {
        name = "${pname}-bundle";
        url = "https://download3.ebz.epson.net/dsc/f/03/00/16/14/38/7b1780ace96e2c6033bbb667c7f3ed281e4e9f38/epsonscan2-bundle-6.7.70.0.x86_64.deb.tar.gz";
        hash = "sha256-fPNNFgW/VU/YG+jjmSvPZ0WsHibsXY1TNp164GxLHKw=";
      };
    }
    ."${system}" or (throw "Unsupported system: ${system}");

in
stdenv.mkDerivation {
  inherit pname src version;

  patches = [
    ./build.patch
    ./gcc14.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/flathub/net.epson.epsonscan2/a489ac2f8cbd03afeda86673930cc17663c31a53/patches/0002-Fix-crash.patch";
      hash = "sha256-rNsFnHq//CJcIZl0M6RLRkIY3YhnJZbikO8SeeC2ktg=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/flathub/net.epson.epsonscan2/a489ac2f8cbd03afeda86673930cc17663c31a53/patches/0004-Fix-a-crash-on-an-OOB-container-access.patch";
      hash = "sha256-WmA8pmPSJ1xUdeBbE8Jzi6w9p96aIOm0erF3T4EQ6VA=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/flathub/net.epson.epsonscan2/a489ac2f8cbd03afeda86673930cc17663c31a53/patches/0003-Use-XDG-open-to-open-the-directory.patch";
      hash = "sha256-H3lle1SXkkpbBkozYEwiX0z9oTUubTpB+l91utxH03M=";
    })
  ];

  postPatch = ''
    substituteInPlace src/Controller/Src/Scanner/Engine.cpp \
      --replace-fail '@KILLALL@' ${lib.getExe killall}

    substituteInPlace src/Controller/Src/Filter/GetOrientation.cpp \
      --replace-fail '@OCR_ENGINE_GETROTATE@' $out/libexec/epsonscan2-ocr/ocr-engine-getrotate
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withGui [
    imagemagick # to make icons
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals withNonFreePlugins [
    autoPatchelfHook
  ];

  buildInputs = [
    boost186 # uses Boost.Optional but epsonscan2 is pre-C++11.
    libjpeg
    libpng
    libtiff
    libusb1
  ]
  ++ lib.optionals withGui [
    copyDesktopItems
    qt5.qtbase
  ]
  ++ lib.optionals withNonFreePlugins [
    libtool.lib
  ];

  cmakeFlags = [
    # The non-free (Debian) packages uses this directory structure so do the same when compiling
    # from source so we can easily merge them.
    "-DCMAKE_INSTALL_LIBDIR=lib/${system}-gnu"
  ]
  ++ lib.optionals (!withGui) [
    "-DNO_GUI=ON"
  ];

  doInstallCheck = true;

  postInstall = ''
    # But when we put all the libraries in lib/${system}-gnu, then SANE can't find the
    # required libraries so create a symlink to where it expects them to be.
    mkdir -p $out/lib/sane
    for file in $out/lib/${system}-gnu/sane/*.so.*; do
      ln -s $file $out/lib/sane/
    done
  ''
  + lib.optionalString withGui ''
    # The icon file extension is .ico but it's actually a png!
    mkdir -p $out/share/icons/hicolor/{48x48,128x128}/apps
    magick $src/Resources/Icons/escan2_app.ico -resize 48x48 -delete 1,2,3 $out/share/icons/hicolor/48x48/apps/epsonscan2.png
    magick $src/Resources/Icons/escan2_app.ico -resize 128x128 -delete 1,2,3 $out/share/icons/hicolor/128x128/apps/epsonscan2.png
  ''
  + lib.optionalString withNonFreePlugins ''
    ar xf ${bundle}/plugins/epsonscan2-non-free-plugin_*.deb
    tar Jxf data.tar.xz
    cp -r usr/* $out
  '';

  desktopItems = lib.optionals withGui [
    (makeDesktopItem {
      name = "epsonscan2";
      exec = "epsonscan2";
      icon = "epsonscan2";
      desktopName = "Epson Scan 2";
      genericName = "Epson Scan 2";
      comment = description;
      categories = [
        "Graphics"
        "Scanning"
      ];
    })
  ];

  meta = {
    inherit description;
    mainProgram = "epsonscan2";
    longDescription = ''
      The Epson Scan 2 scanner driver, including optional non-free plugins such
      as OCR and network scanning.

      To use the SANE backend:
      ```nix
      {
        hardware.sane.extraBackends = [ pkgs.epsonscan2 ];
      }
      ```

      Overrides can be used to customise this package. For example, to enable
      non-free plugins and disable the Epson GUI:
      ```nix
      pkgs.epsonscan2.override {
        withNonFreePlugins = true;
        withGui = false;
      }
      ```
    '';
    homepage = "https://support.epson.net/linux/en/epsonscan2.php";
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86_64;
    sourceProvenance =
      with lib.sourceTypes;
      [ fromSource ] ++ lib.optionals withNonFreePlugins [ binaryNativeCode ];
    license = with lib.licenses; if withNonFreePlugins then unfree else lgpl21Plus;
    maintainers = with lib.maintainers; [ james-atkins ];
  };
}
