{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consul-alerts";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "0836zicv76sd6ljhbbii1mrzh65pch10w3gfa128iynaviksbgn5";
  };

  postPatch = ''
    go mod init github.com/AcalephStorage/consul-alerts
  '';

  vendorHash = null;

  doCheck = false;

  meta = {
    mainProgram = "consul-alerts";
    description = "Extendable open source continuous integration server";
    homepage = "https://github.com/AcalephStorage/consul-alerts";
    # As per README
    platforms = lib.platforms.linux ++ lib.platforms.freebsd ++ lib.platforms.darwin;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nh2 ];
  };
}
