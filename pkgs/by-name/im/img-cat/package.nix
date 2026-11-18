{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "imgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trashhalo";
    repo = "imgcat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L2Yvp+UR6q45ctKsi0v45lKkSE7eJsUPvG7lpX8M6nQ=";
  };

  vendorHash = "sha256-4kF+LwVNBY770wHLLcVlAqPoy4SNhbp2TxdNWRiJL6Q=";

  meta = {
    description = "Tool to output images as RGB ANSI graphics on the terminal";
    homepage = "https://github.com/trashhalo/imgcat";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "imgcat";
  };
})
