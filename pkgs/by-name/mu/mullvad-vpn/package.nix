{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  alsa-lib,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  pango,
  nspr,
  nss,
  gtk3,
  libgbm,
  libGL,
  wayland,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
  libxcb,
  autoPatchelfHook,
  systemd,
  libnotify,
  libappindicator,
  makeWrapper,
  coreutils,
  gnugrep,

  versionCheckHook,
}:

let
  deps = [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3
    libappindicator
    libnotify
    libgbm
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxcb
    libxshmfence
    nspr
    nss
    systemd
  ];

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  platform = selectSystem {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  };

  hash = selectSystem {
    x86_64-linux = "sha256-HleajbEbw5Z1ab/E4zSR+GxDOIuvegP4N9yRFZYv7z4=";
    aarch64-linux = "sha256-Mm2F6PB15pHgRpsw1c1PjmIAcuGaqhfAeZS5HXdoWRQ=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "mullvad-vpn";
  version = "2026.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/mullvad/mullvadvpn-app/releases/download/${finalAttrs.version}/MullvadVPN-${finalAttrs.version}_${platform}.deb";
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
    libGL
    libnotify
    libappindicator
    wayland
  ];

  postPatch = ''
    patchShebangs opt/Mullvad\ VPN/mullvad-vpn
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mullvad $out/bin

    mv usr/share/* $out/share
    mv usr/bin/* $out/bin
    mv opt/Mullvad\ VPN/* $out/share/mullvad

    ln -s $out/share/mullvad/mullvad-{gui,vpn} $out/bin/
    ln -sf $out/share/mullvad/resources/mullvad-problem-report $out/bin/mullvad-problem-report

    wrapProgram $out/bin/mullvad-vpn \
      --set MULLVAD_DISABLE_UPDATE_NOTIFICATION 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
        ]
      }

    wrapProgram $out/bin/mullvad-daemon \
        --set-default MULLVAD_RESOURCE_DIR "$out/share/mullvad/resources"

    wrapProgram $out/bin/mullvad-gui \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}"

    sed -i "s|Exec.*$|Exec=$out/bin/mullvad-vpn $U|" $out/share/applications/mullvad-vpn.desktop

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    description = "Client for Mullvad VPN";
    changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    mainProgram = "mullvad-vpn";
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
    maintainers = with lib.maintainers; [
      jackr
      airone01
      sigmasquadron
    ];
  };
})
