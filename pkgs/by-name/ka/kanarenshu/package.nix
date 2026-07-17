{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kanarenshu";
  version = "0.1.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nuixyz";
    repo = "kanarenshu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ROpZXGvleciJf+B3KVSIcsSES9+mtdLhcPFtGBpEmqY=";
  };

  vendorHash = "sha256-ES9+l6aDY8Y38yi4ufw2bpBPCW58L2oSlfXzh1TWGRE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal TUI application to practise Japanese from the terminal";
    homepage = "https://github.com/nuixyz/kanarenshu";
    changelog = "https://github.com/nuixyz/kanarenshu/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = lib.platforms.unix;
    mainProgram = "kanarenshu";
  };
})
