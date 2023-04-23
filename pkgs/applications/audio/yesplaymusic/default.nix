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
  pname = "yesplaymusic";
  version = "0.4.7";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version}_amd64.deb";
      hash = "sha256-nnnHE2OgIqoz3dC+G0219FVBhvnWivLW1BX6+NYo6Ng=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/yesplaymusic_${version}_arm64.deb";
      hash = "sha256-+rrhY5iDDt/nYs0Vz5/Ef0sgpsdBKMtb1aVfCZLgRgg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version}-x64.dmg";
      hash = "sha256-z8CASZRWKlj1g3mhxTMMeR4klTvQ2ReSrL7Rt18qQbM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-mac-${version}-arm64.dmg";
      hash = "sha256-McYLczudKG4tRNIw/Ws4rht0n4tiKA2M99yKtJbdlY8=";
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
