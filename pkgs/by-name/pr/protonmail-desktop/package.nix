{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  dpkg,
  electron,
  unzip,
}:

let
  mainProgram = "proton-mail";
in
stdenv.mkDerivation rec {
  pname = "protonmail-desktop";
  version = "1.0.4";

  src =
    {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/proton-mail_${version}_amd64.deb";
        hash = "sha256-KY/rjiJozOQW27FYljy5N1VKuKroJz3V485DPaH01JY=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/Proton.Mail-darwin-x64-${version}.zip";
        hash = "sha256-I5Yj1JR3DaAmC6WKI4X/d/q9rvmsck9SE3Mx3AY6yvU=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/Proton.Mail-darwin-arm64-${version}.zip";
        hash = "sha256-j1F8hhLSq/C1WQXGrYnvFK8nNz4qwoA1ohNzPsS3tiY=";
      };
    }
    .${stdenv.hostPlatform.system};

  sourceRoot = lib.optionalString stdenv.isDarwin ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional stdenv.isLinux dpkg ++ lib.optional stdenv.isDarwin unzip;

  installPhase =
    lib.optionalString stdenv.isLinux ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/share/ $out/
      cp -r usr/lib/proton-mail/resources/app.asar $out/share/
      runHook postInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      runHook preInstall
      mkdir -p $out/{Applications,bin}
      cp -r "Proton Mail.app" $out/Applications/
      makeWrapper $out/Applications/"Proton Mail.app"/Contents/MacOS/Proton\ Mail $out/bin/protonmail-desktop
      runHook postInstall
    '';

  preFixup = lib.optionalString stdenv.isLinux ''
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
    maintainers = with maintainers; [
      rsniezek
      sebtm
      matteopacini
    ];
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    inherit mainProgram;
  };
}
