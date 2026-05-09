{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "anitui";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "typechecks";
    repo = "anitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  subPackages = [ "cmd/anitui" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anitui/anitui/internal/tui.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "a tui for browsing and streaming anime";
    homepage = "https://github.com/typechecks/anitui";
    license = lib.licenses.gpl3Only;
    mainProgram = "anitui";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ typechecks ];
  };
})
