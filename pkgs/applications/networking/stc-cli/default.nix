{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stc";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = pname;
    rev = version;
    sha256 = "sha256-g1zn/CBpLv0oNhp32njeNhhli8aTCECgh92+zn5v+4U=";
  };

  vendorHash = "sha256-0OsxCGCJT5k5bHXNSIL6QiJXj72bzYCZiI03gvHQuR8=";

  meta = with lib; {
    description = "Syncthing CLI Tool";
    homepage = "https://github.com/tenox7/stc";
    changelog = "https://github.com/tenox7/stc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "stc";
  };
}
