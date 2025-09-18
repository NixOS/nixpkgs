{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "git-who";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sinclairtarget";
    repo = "git-who";
    rev = "v${version}";
    hash = "sha256-xpY5XIqlCscwJZhtqdYa1yhR9VWgD8FofDXdZ9+afA8=";
  };

  vendorHash = "sha256-e2P7szjtAn4EFTy+eGi/9cYf/Raw/7O+PbYEOD8i3Hs=";
  # some automated tests require submodule to clone and will fail.
  # see project readme
  doCheck = false;

  meta = {
    description = "Git blame for file trees";
    homepage = "https://github.com/sinclairtarget/git-who";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcparland ];
  };
}
