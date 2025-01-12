{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, buildPackages }:

buildGoModule rec {
  pname = "doctl";
  version = "1.120.1";

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  ldflags = let t = "github.com/digitalocean/doctl"; in [
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
    rev = "v${version}";
    sha256 = "sha256-14oBTAE5/bBSYce9esn9gdMW13CUhB5IKkw9v3Gn6Nc=";
  };

  meta = with lib; {
    description = "Command line tool for DigitalOcean services";
    mainProgram = "doctl";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    maintainers = [ maintainers.siddharthist ];
  };
}
