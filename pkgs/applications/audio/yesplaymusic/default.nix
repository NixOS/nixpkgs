{ lib
, stdenv
, fetchurl
, undmg
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, makeWrapper
, alsa-lib
, at-spi2-atk
, cups
, nspr
, nss
, mesa # for libgbm
, xorg
, xdg-utils
, libdrm
, libnotify
, libsecret
, libuuid
, gtk3
, systemd
}:
let
  pname = "YesPlayMusic";
  version = "0.4.5";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version}_amd64.deb";
      hash = "sha256-igd2MzIjwDSOLP0Xi2mSJnEPGWendggPC/MwTDCDui0=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version}_arm64.deb";
      hash = "sha256-6MZrAJGXuEJ9HMUje3ppTz2rdaBydwoQKBk6af81pT0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version}-x64.dmg";
      hash = "sha256-mvmaSrDoIDeOVylkJCVY97yRUHfEI8CysmKrgBUrFGM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version}-arm64.dmg";
      hash = "sha256-Qo03rGS/qB6Sc1IunU7F81WJ/t+mWR7ZRsKYK97LHik=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  libraries = [
    alsa-lib
    at-spi2-atk
    cups
    nspr
    nss
    mesa
    xorg.libxshmfence
    xorg.libXScrnSaver
    xorg.libXtst
    xdg-utils
    libdrm
    libnotify
    libsecret
    libuuid
    gtk3
  ];

  meta = with lib; {
    description = "A good-looking third-party netease cloud music player";
    homepage = "https://github.com/qier222/YesPlayMusic/";
    license = licenses.mit;
    maintainers = with maintainers; [ ChaosAttractor ];
    platforms = builtins.attrNames srcs;
  };
in
if stdenv.isDarwin
then stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';
}
else stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    makeWrapper
  ];

  buildInputs = libraries;

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/yesplaymusic.desktop \
      --replace "/opt/YesPlayMusic/yesplaymusic" "$out/bin/yesplaymusic"
    makeWrapper $out/opt/YesPlayMusic/yesplaymusic $out/bin/yesplaymusic \
      --argv0 "yesplaymusic" \
      --add-flags "$out/opt/YesPlayMusic/resources/app.asar"

    runHook postInstall
  '';
}
