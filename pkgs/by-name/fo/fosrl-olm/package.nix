{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-4Kg/9X1TVhOZ/ogjiPV9BBr1Nls25ZJNf5HNVSSZEwg=";
  };

  vendorHash = "sha256-EJtcAmioC5EltsBeBa9aNDwKLR8rMQbQ2oHz+OVuZj0=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    mainProgram = "olm";
  };
})
