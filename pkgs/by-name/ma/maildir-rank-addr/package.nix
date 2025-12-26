{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "maildir-rank-addr";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ferdinandyb";
    repo = "maildir-rank-addr";
    tag = "v${version}";
    hash = "sha256-3iDvVeiQjyck4+/IvxOe6w2ebR7yju2dV1ijVpajsKU=";
  };

  vendorHash = "sha256-Wl7KfvNYtvSUiYS1LpN027SrU+K3Uq0UQHv7slC2Xwc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a ranked addressbook from a maildir folder";
    homepage = "https://github.com/ferdinandyb/maildir-rank-addr";
    changelog = "https://github.com/ferdinandyb/maildir-rank-addr/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "maildir-rank-addr";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
