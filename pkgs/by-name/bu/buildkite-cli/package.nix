{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-lmsL73jck3vt6oDP699BrMq0RyrXAUuTjKtvHcNtcZc=";
  };

  vendorHash = "sha256-PZHMJpyZ2w3GFHQW56m+9POyXR6wMt3TmNaQENg9lWw=";

  doCheck = false;

  postPatch = ''
    patchShebangs .buildkite/steps/{lint,run-local}.sh
  '';

  subPackages = [ "cmd/bk" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = with lib; {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
