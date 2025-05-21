{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "stc";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = pname;
    rev = version;
    sha256 = "sha256-ftlq7vrnTb4N2bqwiF9gtRj7hZlo6PTUMb/bk2hn/cU=";
  };

  vendorHash = "sha256-qLpWXikTr+vB2bIw2EqnoJ0uOxUc/qc6SdGEJQXwmTQ=";

  meta = with lib; {
    description = "Syncthing CLI Tool";
    homepage = "https://github.com/tenox7/stc";
    changelog = "https://github.com/tenox7/stc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "stc";
  };
}
