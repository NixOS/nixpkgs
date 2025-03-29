{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vNj1w08g7364DcN2reIdamMxKNApKquf/CvFZx3Gu7A=";
  };

  vendorHash = "sha256-UakVmKimlWRcubUIvVgBO+ffltrPwYHhfXwFNbl3J3I=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "Remote HTTP/1.1 cache for Bazel";
    mainProgram = "bazel-remote";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
