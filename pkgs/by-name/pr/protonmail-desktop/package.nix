{ lib
, stdenv
, fetchurl
, makeWrapper
, dpkg
, electron
}:

let
  mainProgram = "proton-mail";
in stdenv.mkDerivation rec {
  pname = "protonmail-desktop";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/proton-mail_${version}_amd64.deb";
    hash = "sha256-opavVpXQmA/VDZ+K/k0NJFwQHUUJhg+bUm/w8Ertopw=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ dpkg makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-mail/resources/app.asar $out/share/
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/${mainProgram} \
      --add-flags $out/share/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = with lib; {
    description = "Desktop application for Mail and Calendar, made with Electron";
    homepage = "https://github.com/ProtonMail/inbox-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rsniezek sebtm ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    inherit mainProgram;
  };
}

