{
  asar,
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  dpkg,
  electron,
  _7zz,
}:
let
  mainProgram = "proton-mail";
  version = "1.11.0";
  linuxHash = "sha256-kmE4EHp3+Uka83MVfAK1V+MrVUN6YAb6TrZFc64IXLo=";
  darwinHash = "sha256-IPOHSSHxdSaLkYX0deH1RFpi17liq0tenfpNniAlNUc=";
in
stdenv.mkDerivation {
  pname = "protonmail-desktop";
  inherit version;

  src =
    {
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/mail/linux/${version}/ProtonMail-desktop-beta.deb";
        hash = linuxHash;
      };
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/mail/macos/${version}/ProtonMail-desktop.dmg";
        hash = darwinHash;
      };
      "x86_64-darwin" = fetchurl {
        url = "https://proton.me/download/mail/macos/${version}/ProtonMail-desktop.dmg";
        hash = darwinHash;
      };
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      makeWrapper
      asar
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      _7zz
    ];

  # Rebuild the ASAR archive, hardcoding the resourcesPath
  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    asar extract usr/lib/proton-mail/resources/app.asar tmp
    rm usr/lib/proton-mail/resources/app.asar
    substituteInPlace tmp/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/share/proton-mail'"
    asar pack tmp/ usr/lib/proton-mail/resources/app.asar
    rm -fr tmp
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/proton-mail
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-mail/resources/* $out/share/proton-mail/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r "Proton Mail.app" $out/Applications/
  ''
  + ''
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
    ]
    ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    inherit mainProgram;
  };
}
