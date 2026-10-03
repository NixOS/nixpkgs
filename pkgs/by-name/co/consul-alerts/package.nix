{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "consul-alerts";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "AcalephStorage";
    repo = "consul-alerts";
    hash = "sha256-xb6lZ9zK+ohEUO4NDgJktxj4cw0xrgUlNU2bs1n8ZiA=";
  };

  postPatch = ''
    go mod init github.com/AcalephStorage/consul-alerts
  '';

  vendorHash = null;

  doCheck = false;

  meta = {
    mainProgram = "consul-alerts";
    description = "Highly available daemon for sending notifications and reminders based on Consul health checks";
    homepage = "https://github.com/AcalephStorage/consul-alerts";
    # As per README
    platforms = lib.platforms.linux ++ lib.platforms.freebsd ++ lib.platforms.darwin;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nh2 ];
  };
})
