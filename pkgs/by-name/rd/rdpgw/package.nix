{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pam,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "rdpgw";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "bolkedebruin";
    repo = "rdpgw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-shOv/fJrFGQspK2kyO5yX483trnSjwMjsd0UE6glYAI=";
  };

  vendorHash = "sha256-i2CsuC0X9qoQCwNyvKhiVbbRQ2GCJwpDfVfN7HI4U0A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pam ];

  ldflags = [ "-s" ];

  meta = {
    description = "Remote Desktop Gateway";
    homepage = "https://github.com/bolkedebruin/rdpgw";
    changelog = "https://github.com/bolkedebruin/rdpgw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rdpgw";
  };
})
