{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, electron
}:

stdenv.mkDerivation rec {
  pname = "headset";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/headsetapp/headset-electron/releases/download/v${version}/headset_${version}_amd64.deb";
    hash = "sha256-M1HMZgYczZWFq0EGlCMEGOGUNoUcmq37J8Ycen72PhM=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper dpkg ];

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/headset
    cp -R usr/share/{applications,icons} $out/share
    cp -R usr/lib/headset/resources/app.asar $out/share/headset/

    makeWrapper ${electron}/bin/electron $out/bin/headset \
      --add-flags $out/share/headset/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple music player for YouTube and Reddit";
    homepage = "https://headsetapp.co/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ muscaln ];
  };
}
