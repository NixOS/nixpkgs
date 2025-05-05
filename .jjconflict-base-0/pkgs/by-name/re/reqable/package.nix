{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeBinaryWrapper,
  fontconfig,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libdbusmenu,
  libdbusmenu-gtk3,
  libepoxy,
  libgcrypt,
  libgpg-error,
  lz4,
  nspr,
  nss,
  pango,
  util-linux,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reqable";
  version = "2.33.8";

  src = fetchurl {
    url = "https://github.com/reqable/reqable-app/releases/download/${finalAttrs.version}/reqable-app-linux-x86_64.deb";
    hash = "sha256-YCuJpTDJNAHBhTrxl5qvtFnUm4VzhkJ66gaKHhWVBEU=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    atk
    cairo
    fontconfig
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdbusmenu
    libdbusmenu-gtk3
    libepoxy
    libgcrypt
    libgpg-error
    lz4
    nspr
    nss
    pango
    util-linux
    xz
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    substituteInPlace $out/share/applications/reqable.desktop \
      --replace-fail "/usr/share/reqable/" ""

    runHook postInstall
  '';

  preFixup = ''
    mkdir $out/bin
    makeWrapper $out/share/reqable/reqable $out/bin/reqable \
      --prefix LD_LIBRARY_PATH : $out/share/reqable/lib
  '';

  meta = {
    description = "Generation API debugging and testing one-stop solution";
    homepage = "https://reqable.com";
    mainProgram = "reqable";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ emaryn ];
    platforms = [ "x86_64-linux" ];
  };
})
