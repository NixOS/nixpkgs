{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "modd";
  version = "0.8-unstable-2025-05-23";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cortesi";
    repo = "modd";
    rev = "b0059d0906426927e0938dc9a01ada2163d98ba3";
    hash = "sha256-g7wV5+VrycAA0JTJ5VkfW95oTp8Bg8e0x1q8Wmt3TTU=";
  };

  vendorHash = "sha256-AY8h+3uGqrHdf1Vahkzd/Fv5WTZAmTYAj/oBXX8YOBg=";

  ldflags = [
    "-s"
    "-w"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Flexible developer tool that runs processes and responds to filesystem changes";
    mainProgram = "modd";
    homepage = "https://github.com/cortesi/modd";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
