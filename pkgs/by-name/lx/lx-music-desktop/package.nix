{ lib
, stdenv
, fetchurl
, makeWrapper

, dpkg
, libGL
, systemd
, electron_28

, commandLineArgs ? ""
}:

let
  pname = "lx-music-desktop";
  version = "2.8.0";

  buildUrl = version: arch: "https://github.com/lyswhut/lx-music-desktop/releases/download/v${version}/lx-music-desktop_${version}_${arch}.deb";

  srcs = {
    x86_64-linux = fetchurl {
      url = buildUrl version "amd64";
      hash = "sha256-Kt/foI7NrXV+Ex2DxLRyP3bVFw0Bx4TLuMyBMZD0bDw=";
    };

    aarch64-linux = fetchurl {
      url = buildUrl version "arm64";
      hash = "sha256-4X4fXb2V/FigArcIgpgkNBa2+mOemPOx/HkxPlx//gw=";
    };

    armv7l-linux = fetchurl {
      url = buildUrl version "armv7l";
      hash = "sha256-uWEQYOT4wxg6HWoL18mEpWF8pONl5Bwf/bnoN4X+A7c=";
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
    dpkg
    makeWrapper
  ];

  runtimeDependencies = map lib.getLib [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/lx-music-desktop
    cp -r opt/lx-music-desktop/{resources,locales} $out/opt/lx-music-desktop
    cp -r usr/share $out/share

    substituteInPlace $out/share/applications/lx-music-desktop.desktop \
        --replace-fail "/opt/lx-music-desktop/lx-music-desktop" "$out/bin/lx-music-desktop" \

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_28}/bin/electron $out/bin/lx-music-desktop \
        --add-flags $out/opt/lx-music-desktop/resources/app.asar \
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs} \
  '';

  meta = with lib; {
    description = "Music software based on Electron and Vue";
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with maintainers; [ oo-infty ];
  };
}
