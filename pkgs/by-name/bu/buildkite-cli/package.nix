{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "buildkite-cli";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SX80Hw9iaYvdrprI/Y1lYXTaKeGTkeVIBk2UujB//cs=";
  };

  vendorHash = "sha256-9doJSApHYYU9GrXi++WIqtUP743mZeRUCuy2xqO/kGo=";

  doCheck = false;

  postPatch = ''
    patchShebangs .buildkite/steps/{lint,run-local}.sh
  '';

  subPackages = [ "cmd/bk" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ groodt ];
    mainProgram = "bk";
  };
})
