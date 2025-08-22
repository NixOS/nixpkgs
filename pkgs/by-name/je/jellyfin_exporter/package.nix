{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "jellyfin_exporter";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "rebelcore";
    repo = "jellyfin_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fIrjcy6y/Ayj43WeuPNCx3uVJyl5Wf6bWs5ta2PpWc=";
  };

  vendorHash = "sha256-JSOKDbefQyDLNy2y1oW7HUplQw8uhhOGZ+ueWyUYYQ0=";

  preCheck = ''
    GOPATH=$out
  '';

  meta = {
    description = "Jellyfin Media System metrics exporter for prometheus";
    homepage = "https://github.com/rebelcore/jellyfin_exporter";
    license = lib.licenses.asl20;
    mainProgram = "jellyfin_exporter";
    maintainers = with lib.maintainers; [ pizzapim ];
  };
})
