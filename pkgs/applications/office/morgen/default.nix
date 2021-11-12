{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, alsa-lib, gtk3, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "morgen";
  version = "2.3.2";

  src = fetchurl {
    url = "https://download.todesktop.com/210203cqcj00tw1/morgen-${version}.deb";
    sha256 = "sha256-rlXCZtIw0kkI2rxn41yW1dTAwwDgcqD/FET5fOP4DJg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ alsa-lib gtk3 libxshmfence mesa nss ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    substituteInPlace $out/share/applications/morgen.desktop \
      --replace '/opt/Morgen' $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/morgen \
      --add-flags $out/opt/Morgen/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "All-in-one Calendars, Tasks and Scheduler";
    homepage = "https://morgen.so/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
