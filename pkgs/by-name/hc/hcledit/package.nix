{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "hcledit";
    rev = "v${version}";
    hash = "sha256-4PBEcOK16YXQhrQ6Yrtcb6vTE6h6sSY3Ymuxi+mEUt8=";
  };

  vendorHash = "sha256-d1cxzGVBOwNAoOxGanRJas4jocxj6B6k5C1hxZi7/Ak=";

  meta = with lib; {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
