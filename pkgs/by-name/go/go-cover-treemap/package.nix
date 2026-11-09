{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-cover-treemap";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "nikolaydubina";
    repo = "go-cover-treemap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y5hy+2uqMjeACjmel16Uf0vgiMSVySdxpSDKOBuxVds=";
  };

  vendorHash = "sha256-JWeCwsPFbQWI60i60GFSQcy7MJ0nDraRb0xf1t4H8RY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Go code coverage to SVG treemap";
    homepage = "https://github.com/nikolaydubina/go-cover-treemap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "go-cover-treemap";
  };
})
