{
  lib,
  stdenv,
  fetchurl,
  undmg,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  gdk-pixbuf,
  glibc,
  nss,
  udev,
  xorg,
  gnome-keyring,
  mesa,
  gtk3,
  libusb1,
  libsecret,
  libappindicator,
  xdotool,
}:
let
  pname = "keeweb";
  version = "1.18.7";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.linux.x64.deb";
      hash = "sha256-/U+vn5TLIU9/J6cRFjuAdyGzlwC04mp4L2X2ETp+ZSE=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.x64.dmg";
      hash = "sha256-+ZFGrrw0tZ7F6lb/3iBIyGD+tp1puVhkPv10hfp6ATU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.arm64.dmg";
      hash = "sha256-bkhwsWYLkec16vMOfXUce7jfrmI9W2xHiZvU1asebK4=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  libraries = [
    alsa-lib
    at-spi2-atk
    gdk-pixbuf
    nss
    udev
    xorg.libX11
    xorg.libXcomposite
    xorg.libXext
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxshmfence
    gnome-keyring
    mesa
    gtk3
    libusb1
    libsecret
    libappindicator
    xdotool
  ];

  meta = with lib; {
    description = "Free cross-platform password manager compatible with KeePass";
    mainProgram = "keeweb";
    homepage = "https://keeweb.info/";
    changelog = "https://github.com/keeweb/keeweb/blob/v${version}/release-notes.md";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = builtins.attrNames srcs;
  };
in
if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  }
else
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
    ];

    buildInputs = libraries;

    unpackPhase = ''
      ${dpkg}/bin/dpkg-deb --fsys-tarfile $src | tar --extract
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r usr/share $out/share

      makeWrapper $out/share/keeweb-desktop/keeweb $out/bin/keeweb \
        --argv0 "keeweb" \
        --add-flags "$out/share/keeweb-desktop/resources/app.asar" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}"

      runHook postInstall
    '';
  }
