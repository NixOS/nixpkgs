{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mouseless";
  version = "0.4.0";

  vendorHash = "sha256-X5qNtvUMM5UFcH7zAryAU/WnBUpkNpY+KwA/Hy1U+OQ=";

  src = fetchFromGitHub {
    owner = "jbensmann";
    repo = "mouseless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iWGxtx76+Fwuo3+SJ/mklu/4nLG/rbgF7/jF+2zME2g=";
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
