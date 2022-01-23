{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, alsa-lib, gtk3, libxshmfence, mesa, nss, popt }:

stdenv.mkDerivation rec {
  pname = "binance";
  version = "1.30.1";

  src = fetchurl {
    url = "https://github.com/binance/desktop/releases/download/v${version}/${pname}-${version}-amd64-linux.deb";
    sha256 = "sha256-Su8pVf5GSBK770D778MmrgYr0ov/JBTNcnL8EZzoG3U=";
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
