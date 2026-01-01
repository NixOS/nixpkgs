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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reqable";
<<<<<<< HEAD
  version = "3.0.31";

  src = fetchurl {
    url = "https://github.com/reqable/reqable-app/releases/download/${finalAttrs.version}/reqable-app-linux-x86_64.deb";
    hash = "sha256-GNxSGw00nnM9bN46sL7G4KcXnJ3gDXv8Xf3N0qbL/ao=";
=======
  version = "2.33.12";

  src = fetchurl {
    url = "https://github.com/reqable/reqable-app/releases/download/${finalAttrs.version}/reqable-app-linux-x86_64.deb";
    hash = "sha256-LCHeJUzTRjl/lh3PWygZV0Rd3AxJEGlTkVrI/5l+Go4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      --prefix LD_LIBRARY_PATH : $out/share/reqable/lib \
      --set GIO_MODULE_DIR "${glib.out}/lib/gio/modules"
=======
      --prefix LD_LIBRARY_PATH : $out/share/reqable/lib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generation API debugging and testing one-stop solution";
    homepage = "https://reqable.com";
<<<<<<< HEAD
    downloadPage = "https://github.com/reqable/reqable-app/releases";
    changelog = "https://github.com/reqable/reqable-app/releases/tag/${finalAttrs.version}";
    mainProgram = "reqable";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ chillcicada ];
=======
    mainProgram = "reqable";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
})
