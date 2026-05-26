{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gh-screensaver";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vilmibm";
    repo = "gh-screensaver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MqwaqXGP4E+46vpgftZ9bttmMyENuojBnS6bWacmYLE=";
  };

  vendorHash = "sha256-o9B6Q07GP/CFekG3av01boZA7FdZg4x8CsLC3lwhn2A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "gh extension with animated terminal screensavers";
    homepage = "https://github.com/vilmibm/gh-screensaver";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "gh-screensaver";
  };
})
