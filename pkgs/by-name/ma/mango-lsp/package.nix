{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mango-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ernestoCruz05";
    repo = "mangolsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uyUZddpGZodNwgP0trwggKejIjGuLkMK3q45qrZyBsg=";
  };

  postPatch = ''
    rm -rf vendor
  '';

  vendorHash = "sha256-ojp/l2cc64wimABFH13tonHr5fmvzd4c81PsPCBRG0I=";

  subPackages = [ "cmd/mangolsp" ];

  ldflags = [
    "-s"
    "-w"
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for mango (mangowm) config files";
    homepage = "https://github.com/ernestoCruz05/mangolsp";
    changelog = "https://github.com/ernestoCruz05/mangolsp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yvnth ];
    mainProgram = "mangolsp";
    platforms = lib.platforms.linux;
  };
})
