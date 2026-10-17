{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "kwakd";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "fetchinson";
    repo = "kwakd";
    rev = "acdf0e1491204ae30622a60fde0bcae4769f78be";
    hash = "sha256-0g7qzPV+xzrhBQGFTrvsEDgrgletB4dhm7P2lZ9NzsY=";
  };

  postInstall = ''
    serviceDir=$out/share/dbus-1/system-services
    mkdir -p $serviceDir
    cp kwakd.service $serviceDir/
    substituteInPlace $serviceDir/kwakd.service \
      --replace "kwakd -p 80" "$out/bin/kwakd -p 80"
  '';

  meta = {
    description = "Super small webserver that serves blank pages";
    homepage = "https://github.com/fetchinson/kwakd";
    mainProgram = "kwakd";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.nicknovitski ];
    platforms = lib.platforms.unix;
  };
}
