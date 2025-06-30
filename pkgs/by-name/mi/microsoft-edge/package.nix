{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,

  # Mandatory to run
  alsa-lib,
  atk,
  cairo,
  nss,
  pango,
  qt6,
  vulkan-loader,
  xorg,
  libgcc,
  libgbm,
  libsecret,
  libGL,
  libxml2,

  # Can start without those, they mostly come from
  # dependencies in the debian package
  cups,
  curlWithGnuTls,
  dbus,
  nspr,
  libuuid,
  wget,
  xdg-utils,
  libxkbcommon,
}:
let
  baseLink = "https://packages.microsoft.com/repos/edge/pool/main";

  # https://gitlab.gnome.org/GNOME/libxml2/-/commit/d9ea76505dff800d89b430b5231f508bf4128c72
  # https://github.com/NixOS/nixpkgs/pull/396195#issuecomment-2993452568
  # https://github.com/NixOS/nixpkgs/pull/418543
  # https://github.com/NixOS/nixpkgs/pull/418679
  # https://github.com/NixOS/nixpkgs/pull/420487
  older-libxml2 = libxml2.overrideAttrs rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "microsoft-edge";
  version = "138.0.3351.55-1";

  src = fetchurl {
    url = "${baseLink}/m/microsoft-edge-stable/microsoft-edge-stable_${version}_amd64.deb";
    hash = "sha256-SZCtAjhzY8BqwM9IMS2081RWxRT+4gQgrjve7avM7Bo=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc
    libgcc
    qt6.qtbase
    xorg.libXrandr
    xorg.libXdamage
    nss
    alsa-lib
    atk
    cairo
    pango
    libgbm
    libsecret
    older-libxml2
  ];

  runtimeDependencies = [
    libGL
    vulkan-loader
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    libxkbcommon
    libuuid

    wget
    xdg-utils
  ];

  installPhase = ''
    runHook preInstall

    # Qt5 is only used as a fallback and we can't
    # combine both qt5.base and qt6.base.
    rm opt/microsoft/msedge/libqt5_shim.so

    # Not needed
    rm opt/microsoft/msedge/microsoft-edge
    rm opt/microsoft/msedge/xdg-mime
    rm opt/microsoft/msedge/xdg-settings
    rm opt/microsoft/msedge/libvulkan.so.1

    mkdir $out
    cp -r opt/microsoft/msedge/ $out/bin
    cp -r usr/share/ $out/share

    # runtimeDependencies doesn't work properly?
    makeWrapper $out/bin/msedge $out/bin/msedge-wrapped \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies} \
      --set LD_LIBRARY_PATH '${lib.makeLibraryPath runtimeDependencies}' \
      --set CHROME_WRAPPER "$out/bin/msedge-wrapper" \
      --set CHROME_VERSION_EXTRA 'stable' \
      --set GNOME_DISABLE_CRASH_DIALOG 'SET_BY_GOOGLE_CHROME' \
      --set SSL_CERT_FILE '/etc/ssl/certs/ca-bundle.crt'

    substituteInPlace \
      $out/share/applications/microsoft-edge.desktop \
      $out/share/applications/com.microsoft.Edge.desktop \
      --replace-fail \
        'Exec=/usr/bin/microsoft-edge-stable' \
        "Exec=$out/bin/msedge-wrapped"

    runHook postInstall
  '';

  meta = {
    changelog = "https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel";
    description = "Web browser from Microsoft";
    homepage = "https://www.microsoft.com/en-us/edge";
    license = lib.licenses.unfree;
    mainProgram = "microsoft-edge";
    maintainers = with lib.maintainers; [ Soveu ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
