{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule rec {
  pname = "doctl";
  version = "1.148.0";

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  ldflags =
    let
      t = "github.com/digitalocean/doctl";
    in
    [
      "-X ${t}.Major=${lib.versions.major version}"
      "-X ${t}.Minor=${lib.versions.minor version}"
      "-X ${t}.Patch=${lib.versions.patch version}"
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
    tag = "v${version}";
    hash = "sha256-iQJ9P2hEDvL1VwUdwH4mbglJ9oO/4XyH7FX0F0J6+TI=";
  };

  meta = {
    description = "Command line tool for DigitalOcean services";
    mainProgram = "doctl";
    homepage = "https://github.com/digitalocean/doctl";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.siddharthist ];
  };
}
