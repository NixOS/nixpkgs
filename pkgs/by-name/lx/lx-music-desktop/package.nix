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
  version = "2.7.0";

  buildUrl = version: arch: "https://github.com/lyswhut/lx-music-desktop/releases/download/v${version}/lx-music-desktop_${version}_${arch}.deb";

  srcs = {
    x86_64-linux = fetchurl {
      url = buildUrl version "amd64";
      hash = "sha256-+mCAFfiJwa+RQ/9vnSPDrC1LoLIoZyFUEJAF6sXdqRM=";
    };

    aarch64-linux = fetchurl {
      url = buildUrl version "arm64";
      hash = "sha256-fDlgHJqoZLGnUuZeZGdocYLbsE02QBrWPKS31fbGThk=";
    };

    armv7l-linux = fetchurl {
      url = buildUrl version "armv7l";
      hash = "sha256-X6EXsBvTbPGXCJ+ektMCMGDG2zqGKBvWT/TwjGFL3ug=";
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
    description = "A music software based on Electron and Vue";
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with maintainers; [ oo-infty ];
  };
}
