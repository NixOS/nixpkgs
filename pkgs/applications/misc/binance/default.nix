{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron_12,
alsa-lib, gtk3, libxshmfence, mesa, nss, popt }:

let
  electron = electron_12;

in stdenv.mkDerivation rec {
  pname = "binance";
  version = "1.26.0";

  src = fetchurl {
    url = "https://github.com/binance/desktop/releases/download/v${version}/${pname}-${version}-amd64-linux.deb";
    sha256 = "sha256-UNqz/0IQ1nWANk83X7IVwvZTJayqNO5xPS6oECCgqHI=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ alsa-lib gtk3 libxshmfence mesa nss popt ];

  libPath = lib.makeLibraryPath buildInputs;

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/binance.desktop --replace '/opt/Binance' $out/bin

    makeWrapper ${electron}/bin/electron \
      $out/bin/binance \
      --add-flags $out/opt/Binance/resources/app.asar \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with lib; {
    description = "Binance Cryptoexchange Official Desktop Client";
    homepage = "https://www.binance.com/en/desktop-download";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
