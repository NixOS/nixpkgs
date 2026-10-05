{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "meowfetch";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faynopi";
    repo = "meowfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5nUogUYc25FPQKY9oIU2bmOpgWN8bCoxEhRJQfEZOcM=";
  };

  vendorHash = "sha256-PnkXXNr+kIige1YB/vEG+sYI0X/rr+6Gtcnb0rW4YK0=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal system information fetcher program written in go";
    homepage = "https://github.com/faynopi/meowfetch";
    changelog = "https://github.com/faynopi/meowfetch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goobertony ];
    mainProgram = "meowfetch";
  };
})
