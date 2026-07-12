{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "batctl-tui";
  version = "2026.3.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Ooooze";
    repo = "batctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-beRADDp3jqrM32ghaPz0IZLT9ZnHO1hnbCkeRz1h5bE=";
  };

  vendorHash = "sha256-irJksXupZGHzZ5vbFeI9laKi5+LyATc1lMxpMLLl69w=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Battery charge threshold manager for Linux laptops";
    homepage = "https://github.com/Ooooze/batctl";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nuexq ];
    mainProgram = "batctl";
  };
})
