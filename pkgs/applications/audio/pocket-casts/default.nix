{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron_12,
alsa-lib, gtk3, libXScrnSaver, libXtst, mesa, nss }:

let
  # Using Electron 12 to solve errors regarding threading
  electron = electron_12;

in stdenv.mkDerivation rec {
  pname = "pocket-casts";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/felicianotech/pocket-casts-desktop-app/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-frBtIxwRO/6k6j0itqN10t+9AyNadqXm8vC1YP960ts=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ alsa-lib gtk3 libXScrnSaver libXtst mesa nss ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out
    mv "$out/opt/Pocket Casts" $out/opt/pocket-casts
    mv $out/share/icons/hicolor/0x0 $out/share/icons/hicolor/256x256

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/pocket-casts.desktop --replace '"/opt/Pocket Casts/pocket-casts"' $out/bin/pocket-casts
    substituteInPlace $out/share/applications/pocket-casts.desktop --replace '/usr/share/icons/hicolor/0x0/apps/pocket-casts.png' "pocket-casts"
    makeWrapper ${electron}/bin/electron \
      $out/bin/pocket-casts \
      --add-flags $out/opt/pocket-casts/resources/app.asar
  '';

  meta = with lib; {
    description = "Pocket Casts webapp, packaged for the Linux Desktop";
    homepage = "https://github.com/felicianotech/pocket-casts-desktop-app";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
