{ lib, stdenv
, fetchurl
, dpkg
, makeWrapper
, electron
, asar
}:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  sha256 = {
    "x86_64-linux" = "139nlr191bsinx6ixpi2glcr03lsnzq7b0438h3245napsnjpx6p";
  }."${system}" or throwSystem;

  arch = {
    "x86_64-linux" = "amd64";
  }."${system}" or throwSystem;

in

stdenv.mkDerivation rec {
  pname = "terra-station";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/terra-money/station-desktop/releases/download/v${version}/Terra.Station_${version}_${arch}.deb";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper asar ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}

    cp -a usr/share/* $out/share
    cp -a "opt/Terra Station/"{locales,resources} $out/share/${pname}

    # patch pre-built node modules
    asar e $out/share/${pname}/resources/app.asar asar-unpacked
    find asar-unpacked -name '*.node' -exec patchelf \
      --add-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      {} \;
    asar p asar-unpacked $out/share/${pname}/resources/app.asar

    substituteInPlace $out/share/applications/station-electron.desktop \
      --replace "/opt/Terra Station/station-electron" ${pname}

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.aasar
  '';

  meta = with lib; {
    description = "Terra station is the official wallet of the Terra blockchain";
    homepage = "https://docs.terra.money/docs/learn/terra-station/README.html";
    license = licenses.isc;
    maintainers = [ maintainers.peterwilli ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "terra-station";
  };
}
