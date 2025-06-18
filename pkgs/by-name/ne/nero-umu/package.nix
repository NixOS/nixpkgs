{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  qt6Packages,
  icu,
  icoextract,
  icoutils,
  umu-launcher,
  winetricks,
  curl,
}:
stdenv.mkDerivation rec {
  pname = "nero-umu";
  version = "v1.1.1";

  src = fetchFromGitHub {
    owner = "SeongGino";
    repo = "Nero-umu";
    rev = "${version}";
    sha256 = "sha256-sX/Z/b5stauut8qg6IV/DdsCIkdx1N3+y1jwoXHr1LY=";
  };

  #Replace quazip git submodule with pre-packaged quazip
  postUnpack = ''
    rmdir source/lib/quazip/
    ln -s ${qt6Packages.quazip.src} source/lib/quazip
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qt5compat
    qt6Packages.quazip
    icu
    icoextract
    icoutils
    umu-launcher
    winetricks
    curl
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DNERO_QT_VERSION=Qt6 -S .."
  ];

  patches = [
    ./nero-binary.patch
  ];

  #Fixes to be able to find binaries for nix
  #Note that these fixes are only possible after patches to the source code
  postPatch = ''
    substituteInPlace src/nerofs.cpp \
      --replace-fail '/usr/bin/icoextract' "${icoextract}/bin/icoextract" \
      --replace-fail '/usr/bin/icotool' "${icoutils}/bin/icotool" \
      --replace-fail '/usr/bin/umu-run' "${umu-launcher}/bin/umu-run" \
      --replace-fail '/usr/bin/winetricks' "${winetricks}/bin/winetricks"

    substituteInPlace src/neroprefixsettings.cpp \
      --replace-fail '/usr/bin/curl' "${curl}/bin/curl"
  '';

  installPhase = ''
    install -Dm755 "nero-umu" "$out/bin/nero-umu"
    install -Dm755 "${src}/img/ico/ico_32.png" "$out/share/icons/hicolor/32x32/apps/xyz.TOS.Nero.png"
    install -Dm755 "${src}/img/ico/ico_48.png" "$out/share/icons/hicolor/48x48/apps/xyz.TOS.Nero.png"
    install -Dm755 "${src}/img/ico/ico_64.png" "$out/share/icons/hicolor/64x64/apps/xyz.TOS.Nero.png"
    install -Dm755 "${src}/img/ico/ico_128.png" "$out/share/icons/hicolor/128x128/apps/xyz.TOS.Nero.png"
    install -Dm755 "${src}/xyz.TOS.Nero.desktop" "$out/share/applications/xyz.TOS.Nero.desktop"
  '';

  meta = {
    homepage = "https://github.com/SeongGino/Nero-umu";
    description = "A fast and efficient Proton prefix runner and manager, using umu as its backend for Steam-like compatibility with non-Steam applications.";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nero-umu";
    platforms = ["x86_64-linux"];
    maintainers = with lib.maintainers; [ern775 blghnks];
  };
}
