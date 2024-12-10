{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ...
}:
buildGoModule rec {
  pname = "maildir-rank-addr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ferdinandyb";
    repo = "maildir-rank-addr";
    tag = "v${version}";
    hash = "sha256-LABqd9FojbQUG3c0XBH5ZKsJNPTMEt3Yzn6gpYEWddc=";
  };

  vendorHash = "sha256-Mqx938j8LwM+bDnrK3V46FFy86JbVoh9Zxr/CA/egk8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a ranked addressbook from a maildir folder";
    homepage = "https://github.com/ferdinandyb/maildir-rank-addr";
    license = lib.licenses.mit;
    mainProgram = "maildir-rank-addr";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
