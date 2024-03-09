{ pkgs
, lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, ...
}:
with lib;
stdenv.mkDerivation (finalAttrs: {
  pname = "figma-linux";
  version = "0.11.3";

  src = fetchurl {
    url = "https://github.com/Figma-Linux/figma-linux/releases/download/v${finalAttrs.version}/figma-linux_${finalAttrs.version}_linux_amd64.deb";
    hash = "sha256-9UfyCqgsg9XAFyZ7V7TogkQou4x+ixFUfjXZ1/qlDmA=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapGAppsHook ];

  buildInputs = with pkgs;[
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
    mesa
    nspr
    nss
    pango
  ] ++ (with pkgs.xorg; [
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib && cp -r opt/figma-linux/* $_
    mkdir -p $out/bin && ln -s $out/lib/figma-linux $_/figma-linux

    cp -r usr/* $out

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/figma-linux.desktop \
          --replace "Exec=/opt/figma-linux/figma-linux" "Exec=$out/bin/${finalAttrs.pname}"
  '';

  meta = {
    description = "Unofficial Electron-based Figma desktop app for Linux";
    homepage = "https://github.com/Figma-Linux/figma-linux";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ercao kashw2 ];
    mainProgram = "figma-linux";
  };
})
