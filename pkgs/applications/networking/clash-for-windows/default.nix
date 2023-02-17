{ lib
, stdenv
, fetchurl
, copyDesktopItems
, makeDesktopItem
, nodePackages
, autoPatchelfHook
, wrapGAppsHook
, nss
, nspr
, cups
, libdrm
, alsa-lib
, mesa
, nix-update-script
}:

let
  version = "0.20.16";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Fndroid/clash_for_windows_pkg/releases/download/${version}/Clash.for.Windows-${version}-x64-linux.tar.gz";
      sha256 = "1yz0sgm1csf0n8wrx1gsnhm557qdlyljw76hln0g3h4bmlypkkm5";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Fndroid/clash_for_windows_pkg/releases/download/${version}/Clash.for.Windows-${version}-arm64-linux.tar.gz";
      sha256 = "11r8yxi148g8dash6ksd1zahlv81s5z58qfrmm7y9cprplxnfdz1";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "clash-for-windows";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    copyDesktopItems
    nodePackages.asar
  ];

  buildInputs = [
    nss
    nspr
    cups
    libdrm
    alsa-lib
    mesa
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r . $out/opt/${pname}

    mkdir -p $out/bin
    ln -s $out/opt/${pname}/cfw $out/bin/cfw

    mkdir app-extract
    asar extract resources/app.asar app-extract
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp app-extract/dist/electron/static/imgs/icon_512.png "$out/share/icons/hicolor/512x512/apps/${pname}.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "cfw";
      icon = pname;
      comment = meta.description;
      desktopName = "Clash For Windows";
      categories = [ "Network" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/Fndroid/clash_for_windows_pkg";
    description = "A Windows/macOS/Linux GUI based on Clash and Electron";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ candyc1oud ];
  };
}
