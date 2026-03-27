{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libayatana-appindicator,
  openssl,
  glib-networking,
}:

stdenv.mkDerivation rec {
  pname = "clippy-clipboard";
  version = "1.5.8";

  src = fetchurl {
    url = "https://github.com/0-don/clippy/releases/download/v${version}/clippy_${version}_amd64.deb";
    hash = "sha256-w0E2MCpI1ZaMvYKkkPiISAzHjDrILUkUXL58Clesv4I=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libayatana-appindicator
    openssl
    glib-networking
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Clipboard manager built with Rust and TypeScript";
    homepage = "https://github.com/0-don/clippy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0don ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "clippy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
