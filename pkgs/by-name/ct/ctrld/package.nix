{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "ctrld";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Control-D-Inc";
    repo = "ctrld";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KrkEI07wfddDGmor2VT3I5gGmeZX75UGLZl++a6sE+c=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  vendorHash = "sha256-rsRlInNk6/C9DzJLbCoQSbV1exGfstbTxE8qitKmZ0c=";
  subPackages = [ "cmd/ctrld" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Control-D-Inc/ctrld/cmd/cli.version=v${finalAttrs.version}"
  ];

  meta = {
    license = lib.licenses.mit;
    description = "A highly configurable, multi-protocol DNS forwarding proxy";
    homepage = "https://github.com/Control-D-Inc/ctrld";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    mainProgram = "ctrld";
  };
})
