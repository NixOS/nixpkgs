{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation {
  pname = "ffda-network-setup-mode-send-request";
  version = "1.0.0";

  src = fetchgit {
    url = "https://github.com/freifunk-gluon/community-packages.git";
    rev = "1493e17ff7574dd0fd0bbab7b4d4e3a6ac83656f";
    sha256 = "sha256-/2WvdQULS8d+PVJuHvod7AL2VF8RQ4hgzIGBu+KR5ME=";
    sparseCheckout = [
      "ffda-network-setup-mode/src"
    ];
    deepClone = false;
  };

  buildPhase = ''
    cd ffda-network-setup-mode/src
    make send-network-request
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp send-network-request $out/bin/ffda-network-setup-mode-send-request
  '';

  meta = {
    description = "Activate freifunk-gluon setup-mode using a magic packet.";
    homepage = "https://github.com/freifunk-gluon/community-packages/tree/main/ffda-network-setup-mode";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ herbetom ];
    mainProgram = "ffda-network-setup-mode-send-request";
  };
}
