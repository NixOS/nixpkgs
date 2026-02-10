{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "doctl";
  version = "1.150.0";

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  ldflags =
    let
      t = "github.com/digitalocean/doctl";
    in
    [
      "-X ${t}.Major=${lib.versions.major finalAttrs.version}"
      "-X ${t}.Minor=${lib.versions.minor finalAttrs.version}"
      "-X ${t}.Patch=${lib.versions.patch finalAttrs.version}"
      "-X ${t}.Label=release"
    ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME=$(mktemp -d) # attempts to write to /homeless-shelter
    for shell in bash fish zsh; do
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/doctl completion $shell > doctl.$shell
      installShellCompletion doctl.$shell
    done
  '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7sxWxiWCdPU52i8uhplOqZFS5WPBMmSNgPqLp1cEI8=";
  };

  meta = {
    description = "Command line tool for DigitalOcean services";
    mainProgram = "doctl";
    homepage = "https://github.com/digitalocean/doctl";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.siddharthist ];
  };
})
