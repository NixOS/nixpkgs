{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "qrc";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fumiyas";
    repo = "qrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d0WGfdPC61PFLkxYFs+rdQnUUnR/gkYFyblOvdIUkl8=";
  };

  vendorHash = "sha256-u30FC0Agx/vnXWqXgF2LcaDjnbZn2tj2yNyB6KfgjV0=";

  meta = {
    homepage = "https://github.com/fumiyas/qrc";
    description = "QR code generator for text terminals";
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "qrc";
  };
})
