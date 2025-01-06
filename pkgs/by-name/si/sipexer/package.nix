{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sipexer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "miconda";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/AVOC8Tx5XMDiKmLBq2xUiJaA3K3TnWVXPE+Vzx862I=";
  };

  vendorHash = "sha256-q2uNqKZc6Zye7YimPDrg40o68Fo4ux4fygjVjJdhqQU=";

  meta = {
    description = "Modern and flexible SIP CLI tool";
    homepage = "https://github.com/miconda/sipexer";
    changelog = "https://github.com/miconda/sipexer/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ astro ];
    mainProgram = "sipexer";
  };
}
