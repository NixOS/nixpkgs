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
  version = "6.7.90.0-2026-01";

  system = stdenv.hostPlatform.system;

  src = fetchzip {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/17/08/06/1babf9876ebb16956420a601b92ee28b57cd7db7/epsonscan2-6.7.80.0-1.src.tar.gz";
    hash = "sha256-SHNpnVyoFTwLu3drlL8MFKj/NCKy5U0UDqP08f7u1R4=";
  };
  bundle =
    {
      "x86_64-linux" = fetchzip {
        name = "${pname}-bundle";
        url = "https://download3.ebz.epson.net/dsc/f/03/00/17/08/12/9f3fec0ae80aa5c36f5170377ebcc38c93251e23/epsonscan2-bundle-6.7.80.0.x86_64.deb.tar.gz";
        hash = "sha256-Smjp2PRcsNN9nP3W++HmKOw85zZj20zEIFEEVSO8lDo=";
      };
    }
    ."${system}" or (throw "Unsupported system: ${system}");

in
stdenv.mkDerivation {
  inherit pname src version;

  patches = [
    ./build.patch
    ./gcc15.patch
    (fetchpatch {
      url = "https://github.com/flathub/net.epson.epsonscan2/raw/f9eb99109e63dbed907f46e36f435e46d7c01aad/patches/0002-Fix-crash.patch";
      hash = "sha256-Al5DkVnCBNoMtex4G3Zm7uZwTvnWGAjOk5xh/U9WyNU=";
    })
    # At the time of writing, some flathub patches are not updated to work with 6.7.90.0-1 (2026/01/01)
    ./xdg-open.patch # Rebase of https://github.com/flathub/net.epson.epsonscan2/blob/master/patches/0003-Use-XDG-open-to-open-the-directory.patch
    ./fix-oob-container-access.patch # Rebase of https://github.com/flathub/net.epson.epsonscan2/blob/master/patches/0004-Fix-a-crash-on-an-OOB-container-access.patch
    (fetchpatch {
      url = "https://github.com/flathub/net.epson.epsonscan2/raw/f9eb99109e63dbed907f46e36f435e46d7c01aad/patches/0005-Added-missing-headers.patch";
      hash = "sha256-YJjCI8UNzLciSq9IfcHxiF4isFGM9A5Hn7Kxao/+lpQ=";
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
    # There are many CMakeLists.txt files with various minimum versions. It's much easier to set this
    # here, instead of substituting those everywhere
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
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
