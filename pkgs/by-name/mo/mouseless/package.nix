{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mouseless";
  version = "0.2.0";

  vendorHash = "sha256-2q7L9BVcAaT4h/vUcNjVc5nOAFnb4J3WabcEGxI+hsA=";

  src = fetchFromGitHub {
    owner = "jbensmann";
    repo = "mouseless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iDSTV2ugvHoBuQWmMg2ILXP/Mlt7eq5B2dVaB0jwJOE=";
  };

  meta = {
    description = "Replacement for the mouse in Linux";
    longDescription = ''
      This program allows you to control the mouse pointer in Linux
      with the keyboard. It works in all Linux distributions, even those
      running with Wayland.
    '';
    homepage = "https://github.com/jbensmann/mouseless";
    changelog = "https://github.com/jbensmann/mouseless/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ imsuck ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mouseless";
  };
})
