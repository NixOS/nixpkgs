{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ctrld";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "Control-D-Inc";
    repo = "ctrld";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZiNyB8d4x6SBG5MIGqzHzQgFbMCRunPPpGKzffwmXBM=";
  };

  vendorHash = "sha256-AVR+meUcjpExjUo7J1U6zUPY2B+9NOqBh7K/I8qrqL4=";
  proxyVendor = true;
  subPackages = [ "cmd/ctrld" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Control-D-Inc/ctrld/cmd/cli.version=${finalAttrs.version}"
    "-X github.com/Control-D-Inc/ctrld/cmd/cli.commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Highly configurable, multi-protocol DNS forwarding proxy";
    homepage = "https://github.com/Control-D-Inc/ctrld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GustavoWidman ];
    platforms = lib.platforms.all;
    mainProgram = "ctrld";
  };
})
