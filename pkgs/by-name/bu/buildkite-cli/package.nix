{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-Tb9Hyhyf+ib/tLUHc+gUccZ7TuXltxxjaIpCfvnoVkA=";
  };

  vendorHash = "sha256-1QXcRykXoNGYCR8+6ut1eU8TVNtx8b2O2MIjmL8rfQk=";

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

  meta = {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
