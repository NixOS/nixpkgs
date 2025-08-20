{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  wrapGAppsHook3,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "figma-linux";
  version = "0.11.5";

  src = fetchurl {
    url = "https://github.com/Figma-Linux/figma-linux/releases/download/v${finalAttrs.version}/figma-linux_${finalAttrs.version}_linux_amd64.deb";
    hash = "sha256-6lFeiecliyuTdnUCCbLpoQWiu5k3OPHxb+VF17GtERo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs =
    with pkgs;
    [
      alsa-lib
      at-spi2-atk
      cairo
      cups.lib
      dbus.lib
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libxkbcommon
      libgbm
      nspr
      nss
      pango
    ]
    ++ (with pkgs.xorg; [
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libxcb
      libxshmfence
    ]);

  runtimeDependencies = with pkgs; [ eudev ];

  unpackCmd = "dpkg -x $src .";

  sourceRoot = ".";

  # Instead of double wrapping the binary, simply pass the `gappsWrapperArgs`
  # to `makeWrapper` directly
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib && cp -r opt/figma-linux/* $_
    mkdir -p $out/bin && ln -s $out/lib/figma-linux $_/figma-linux

    cp -r usr/* $out

    wrapProgramShell $out/bin/figma-linux \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/figma-linux.desktop \
          --replace "Exec=/opt/figma-linux/figma-linux" "Exec=$out/bin/${finalAttrs.pname}"
  '';

  meta = with lib; {
    description = "Unofficial Electron-based Figma desktop app for Linux";
    homepage = "https://github.com/Figma-Linux/figma-linux";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ercao
      kashw2
    ];
    mainProgram = "figma-linux";
  };
})
