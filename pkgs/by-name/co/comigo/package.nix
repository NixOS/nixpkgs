{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "comigo";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BGOSDsAYpdyvCy9Ss8CgpPN25lS3sah6QO0B41A1BM0=";
  };

  vendorHash = "sha256-kJ0GTLFG9YF34jKFKjlgvevWxQO6aTNJGl+a/dfTtJ8=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Simple and Efficient Comic Reader";
    homepage = "https://github.com/yumenaka/comigo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "comigo";
  };
})
