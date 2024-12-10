{ buildGoModule, fetchFromGitHub, lib, testers, github-release }:

buildGoModule rec {
  pname = "github-release";
  version = "0.10.1-unstable-2024-06-25";

  src = fetchFromGitHub {
    owner = "github-release";
    repo = "github-release";
    rev = "d250e89a7bf00d54e823b169c3a4722a55ac67b0";
    hash = "sha256-QDImy9VNJ3hfGVCpMoJ72Za3CiM3SVNH1D9RFHVM+4I=";
  };

  vendorHash = null;

  ldflags = [ "-s" ];

  passthru.tests.version = testers.testVersion {
    package = github-release;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    mainProgram = "github-release";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';

    license = licenses.mit;
    homepage = "https://github.com/github-release/github-release";
    maintainers = with maintainers; [ ardumont j03 ];
    platforms = with platforms; unix;
  };
}
