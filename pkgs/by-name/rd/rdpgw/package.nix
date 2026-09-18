{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pam,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "rdpgw";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "bolkedebruin";
    repo = "rdpgw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V0TmRo0MBYrpyn7kmazU93prMOvkkI5/x15P7gV88lA=";
  };

  patches = [ ./go-sum.patch ];

  vendorHash = "sha256-KH3c8IAFkXCDLleRTiTnXx+q6LpLl6oTswwmLZPUUSI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pam ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Remote Desktop Gateway";
    homepage = "https://github.com/bolkedebruin/rdpgw";
    changelog = "https://github.com/bolkedebruin/rdpgw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rdpgw";
  };
})
