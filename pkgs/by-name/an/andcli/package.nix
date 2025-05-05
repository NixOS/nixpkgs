{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "andcli";
  version = "2.1.3";

  subPackages = [ "cmd/andcli" ];

  src = fetchFromGitHub {
    owner = "tjblackheart";
    repo = "andcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MfhChaowSkCggeyubYdlcmU3+dd+yXlVrgdr85xjlI8=";
  };

  vendorHash = "sha256-C5XW3nxTUjcH6YaFYSxuKdtMF5SvrbOjErWIQXNwSJA=";

  meta = {
    homepage = "https://github.com/tjblackheart/andcli";
    description = "2FA TUI for your shell";
    changelog = "https://github.com/tjblackheart/andcli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cameo007 ];
  };
})
