{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gopacked";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "gopacked";
    rev = "v${version}";
    hash = "sha256-PpOLLqgUQf09grZlJ7bXTxAowzDusmVN8PHfaGlGGQ8=";
  };

  vendorHash = "sha256-ooxVXNbqoh3XX3yFemAyqISNZ+PC8WJUe+ch2OnIdDo=";

  doCheck = false;

  meta = with lib; {
    description = "Simple text-based Minecraft modpack manager";
    license = licenses.agpl3Plus;
    homepage = src.meta.homepage;
    maintainers = [ ];
  };
}
