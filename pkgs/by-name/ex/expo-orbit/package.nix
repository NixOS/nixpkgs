{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  alsa-lib,
  cairo,
  cups,
  dbus,
  expat,
  libdrm,
  glib,
  pango,
  nspr,
  nss,
  gtk3,
  libgbm,
  xorg,
  autoPatchelfHook,
  systemd,
  makeWrapper,
  maintainers,
}: let
  deps = [
    alsa-lib
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  version = "2.0.4";

  selectSystem = attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  platform = selectSystem {
    x86_64-linux = "amd64";
  };

  hash = selectSystem {
    x86_64-linux = "sha256-ayT1ol7hocHSqtWAzksT95DYwjmk+95jcrtyt0PtN68=";
  };
in
  stdenv.mkDerivation {
    pname = "expo-orbit";
    inherit version;

    src = fetchurl {
      url = "https://github.com/expo/orbit/releases/download/expo-orbit-v${version}/expo-orbit_${version}_${platform}.deb";
      inherit hash;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    buildInputs = deps;

    dontBuild = true;
    dontConfigure = true;

    runtimeDependencies = [
      (lib.getLib systemd)
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share $out/bin

      mv usr/share/* $out/share
      mv usr/lib/expo-orbit $out/share/

      ln -s $out/share/expo-orbit/expo-orbit $out/bin/

      wrapProgram $out/bin/expo-orbit \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}"

      sed -i "s|Exec.*$|Exec=expo-orbit %U|" $out/share/applications/expo-orbit.desktop

      runHook postInstall
    '';

    doInstallCheck = false;

    passthru.updateScript = ./update.sh;

    meta = {
      homepage = "https://expo.dev/orbit";
      description = "Accelerate your development workflow with one-click build launches and simulator management from your menu bar ";
      changelog = "https://github.com/expo/orbit/releases/tag/expo-orbit-v${version}";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      maintainers = with maintainers; [dreamingcodes];
    };
  }
