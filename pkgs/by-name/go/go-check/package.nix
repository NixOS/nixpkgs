{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule {
  pname = "check";
  version = "0-unstable-2018-12-24";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "opennota";
    repo = "check";
    rev = "ccaba434e62accd51209476ad093810bd27ec150";
    hash = "sha256-u8U/62LZEn1ffwdGsUCGam4HAk7b2LetomCLZzHuuas=";
  };

  vendorHash = "sha256-XgYRw077ry+ZJSuelXH2imYjfTxW+i7nVZ3DurL5UPU=";

  meta = {
    description = "Set of utilities for checking Go sources";
    homepage = "https://gitlab.com/opennota/check";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
