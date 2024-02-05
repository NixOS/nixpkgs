{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, dpkg
, alsa-lib
, at-spi2-atk
, cups
, glib
, gtk3
, libGL
, libdrm
, mesa
, nss
, systemd
, xorg
}:

let
  pname = "lx-music-desktop";
  version = "2.6.0";

  buildUrl = version: arch: "https://github.com/lyswhut/lx-music-desktop/releases/download/v${version}/lx-music-desktop_${version}_${arch}.deb";

  srcs = {
    x86_64-linux = fetchurl {
      url = buildUrl version "amd64";
      hash = "sha256-65mmgKm1ZEwlV8wYm0YJqrYzPuoyHXvAqi+Lc+7wEdA=";
    };

    aarch64-linux = fetchurl {
      url = buildUrl version "arm64";
      hash = "sha256-Hx+L8PunRpBJuOokCYoxOGosrJXbXwkuI9npnmqDK2s=";
    };

    armv7l-linux = fetchurl {
      url = buildUrl version "armv7l";
      hash = "sha256-etblBEWIORiLBcaq2zZ0eQCmZd2FJZFMaan8wSpjVCI=";
    };
  };

  host = stdenv.hostPlatform.system;
  src = srcs.${host} or (throw "Unsupported system: ${host}");

  runtimeLibs = lib.makeLibraryPath [
    libGL
    stdenv.cc.cc.lib
  ];
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cups
    glib
    gtk3
    libdrm
    mesa
    nss
    xorg.libXdamage
  ];

  runtimeDependencies = map lib.getLib [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share

    substituteInPlace $out/share/applications/lx-music-desktop.desktop \
      --replace "/opt/lx-music-desktop/lx-music-desktop" "$out/bin/lx-music-desktop" \

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/lx-music-desktop/lx-music-desktop $out/bin/lx-music-desktop \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = with lib; {
    description = "A music software based on Electron and Vue";
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ oo-infty ];
  };
}
