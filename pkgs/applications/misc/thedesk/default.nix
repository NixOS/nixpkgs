{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, alsa-lib, gtk3, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "thedesk";
  version = "22.3.1";

  src = fetchurl {
    url = "https://github.com/cutls/TheDesk/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-5KB88zMgwfObgmcMTe6R+oG48qLHrMht6vM1EvI+QFY=";
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

    substituteInPlace $out/share/applications/thedesk.desktop \
      --replace '/opt/TheDesk' $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/thedesk \
      --add-flags $out/opt/TheDesk/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mastodon/Misskey Client for PC";
    homepage = "https://thedesk.top";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
