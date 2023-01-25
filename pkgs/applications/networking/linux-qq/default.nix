{ pkgs
, lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, ...
}:
with lib;
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "f0a714859c20785cc6cab4084d69c953310f1993828f42c81cb991b8aaa48264";
    aarch64-linux = "2ef13e3ebcaae0a2eef8115856b1a24f005d80eac182e3c741def730c1657e26";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  version = "3.0.0-571";
  pname = "linux-qq";

  src = fetchurl {
    name = "linuxqq_${version}_${plat}.deb";
    url = "https://dldir1.qq.com/qqfile/qq/QQNT/c005c911/linuxqq_${version}_${plat}.deb";
    inherit sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = with pkgs;[
    alsa-lib
    at-spi2-atk
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
    libgcrypt
    libkrb5
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
    mkdir -p $out/lib && cp -r opt/QQ/* $_
    mkdir -p $out/bin && ln -s $out/lib/qq $_/qq
    cp -r usr/* $out
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/qq.desktop \
          --replace "Exec=/opt/QQ/qq" "Exec=$out/bin/QQ/qq"
  '';

  meta = {
    description = "The official QQ client for linux";
    homepage = "https://im.qq.com";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ krysztal ];
  };
}
