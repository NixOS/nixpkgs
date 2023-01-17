{ pkgs
, lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, ...
}:
stdenv.mkDerivation rec {
  pname = "figma-linux";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/Figma-Linux/figma-linux/releases/download/v${version}/figma-linux_${version}_linux_amd64.deb";
    sha256 = "sha256-+xiXEwSSxpt1/Eu9g57/L+Il/Av+a/mgGBQl/4LKR74=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

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
          --replace "Exec=/opt/figma-linux/figma-linux" "Exec=$out/bin/${pname}"
  '';

  meta = with lib; {
    description = "unofficial Electron-based Figma desktop app for Linux";
    homepage = "https://github.com/Figma-Linux/figma-linux";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2;
    maintainers = with maintainers; [ ercao ];
  };
}
