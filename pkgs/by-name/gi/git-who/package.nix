{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "git-who";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "sinclairtarget";
    repo = "git-who";
    rev = "v${version}";
    hash = "sha256-/MCvFmZNEVnSrSezTiwH3uWPbh/a7mVxmKduc63E3LA=";
  };

  vendorHash = "sha256-VdQw0mBCALeQfPMjQ4tp3DcLAzmHvW139/COIXSRT0s=";
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
