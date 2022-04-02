{ lib, stdenv, fetchurl, rpmextract, wrapGAppsHook, nwjs }:

stdenv.mkDerivation rec {
  pname = "gometer";
  version = "5.2.0";

  src = fetchurl {
    url = "https://gometer-prod-new-apps.s3-accelerate.amazonaws.com/${version}/goMeter-linux64.rpm";
    sha256 = "sha256-E53sVvneW2EMPz9HNCgbGuHnDlVihE+Lf+DkFIP+j28=";
  };

  nativeBuildInputs = [
    rpmextract
    wrapGAppsHook
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    rpmextract ${src}
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    mkdir $out/share/applications
    mv $out/opt/goMeter/goMeter.desktop $out/share/applications/gometer.desktop
    substituteInPlace $out/share/applications/gometer.desktop \
      --replace '/opt/goMeter/' ""

    makeWrapper ${nwjs}/bin/nw $out/bin/goMeter \
      --add-flags $out/opt/goMeter/package.nw

    runHook postInstall
  '';

  meta = with lib; {
    description = "Analytic-Tracking tool for GoLance";
    homepage = "https://golance.com/download-gometer";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
