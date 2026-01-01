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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "consul-alerts";
    description = "Highly available daemon for sending notifications and reminders based on Consul health checks";
    homepage = "https://github.com/AcalephStorage/consul-alerts";
    # As per README
<<<<<<< HEAD
    platforms = lib.platforms.linux ++ lib.platforms.freebsd ++ lib.platforms.darwin;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nh2 ];
=======
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.darwin;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nh2 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
