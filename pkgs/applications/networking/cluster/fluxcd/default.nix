{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles, stdenv }:

let
  version = "0.36.0";
  sha256 = "1rjsdisj2cib8pyfc1lx5jgx0dksh0zhiqccgvqvfja24azvhc4n";
  manifestsSha256 = "0kzbzn43i35kyl7h9kb4f21sbrz90jx9pj35002j2i1j20b2xzh8";

  manifests = fetchzip {
    url =
      "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = manifestsSha256;
    stripRoot = false;
  };

in buildGoModule rec {
  pname = "fluxcd";
  inherit version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    inherit sha256;
  };

  vendorSha256 = "sha256-2N91+anR0nD9E563MgSQPwslR9J/uvSHLs6kD4Yc3So=";

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests
  '';

  patches = [ ./patches/disable-tests-ssh_key.patch ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  subPackages = [ "cmd/flux" ];

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/flux completion $shell > flux.$shell
      installShellCompletion flux.$shell
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description =
      "Open and extensible continuous delivery solution for Kubernetes";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 jlesquembre ];
    mainProgram = "flux";
  };
}
