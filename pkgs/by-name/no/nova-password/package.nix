{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nova-password";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qWpZChgND4M4x1L0/38DSeJyJ0jKkDttzfWzAukROgo=";
  };

  vendorHash = "sha256-s0Abw8lCL3hzil+m/K6CZqVNycnP669Uhv4l4nkMSfc=";

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
})
