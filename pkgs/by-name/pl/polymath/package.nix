{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,
  makeWrapper,

  atk,
  coreutils,
  glib,
  gnugrep,
  libayatana-appindicator,
  libusb1,
  mpv,
  ...
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "amd64"
    else
      throw "Unsupported system ${stdenv.hostPlatform.system} ";
in
stdenv.mkDerivation rec {
  pname = "polymath";
  version = "1.4.0.7";

  src = fetchurl {
    url = "https://fluxkeyboard.com/updates/polymath/linux/deb/polymath_${version}_amd64.deb";
    sha256 = "1182c14ddf6bd2cdc1c66e06cbcc1b08d4b4772b972c8d63b7aada4b3acfff4d";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    atk
    glib
    libayatana-appindicator
    libusb1
    mpv
  ];

  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    mkdir deb
    dpkg-deb -x $src ./deb

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv deb/usr/* $out/
    rmdir deb/usr
    mv deb/* $out/

    # patch launch binary
    makeWrapper $out/opt/polymath/polymath $out/bin/polymath \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gnugrep
          ]
        }

    # Fix Paths in Desktop file
    sed -i -e "s|Exec=.*|Exec=$out/bin/polymath|g" $out/share/applications/polymath.desktop
    sed -i -e "s|Icon=.*|Icon=$out/share/pixmaps/polymath.png|g" $out/share/applications/polymath.desktop

    runHook postInstall
  '';

  meta = {
    description = "Flux Keyboard Software: Polymath";
    homepage = "https://fluxkeyboard.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      darkjaguar91
    ];
    platforms = lib.platforms.linux;
  };
}
