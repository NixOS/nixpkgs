{
  asar,
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  dpkg,
  electron,
}:
let
  mainProgram = "proton-mail";
  version = "1.5.1";

in
stdenv.mkDerivation {
  pname = "protonmail-desktop";
  inherit version;

  src = fetchurl {
    url = "https://proton.me/download/mail/linux/${version}/ProtonMail-desktop-beta.deb";
    sha256 = "sha256-PkxJUzSmSeIf/WjXCj5Pne5DHrXnTRib1IqHtbe3lNA=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  # Rebuild the ASAR archive, hardcoding the resourcesPath
  preInstall = ''
    asar extract usr/lib/proton-mail/resources/app.asar tmp
    rm usr/lib/proton-mail/resources/app.asar
    substituteInPlace tmp/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/share/proton-mail'"
    asar pack tmp/ usr/lib/proton-mail/resources/app.asar
    rm -fr tmp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/proton-mail
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-mail/resources/* $out/share/proton-mail/

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper ${lib.getExe electron} $out/bin/${mainProgram} \
      --add-flags $out/share/proton-mail/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop application for Mail and Calendar, made with Electron";
    homepage = "https://github.com/ProtonMail/WebClients";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      rsniezek
      sebtm
      matteopacini
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    inherit mainProgram;
  };
}
