{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:
let isCrossBuild = stdenv.hostPlatform != stdenv.buildPlatform;

in
buildGoModule rec {
  pname = "stern";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-+V0mRSjAwhZoiIS/OpZyqa5rvlqU9pGJwmW0QZ3H2g4=";
  };

  vendorSha256 = "sha256-IPHu23/2e6406FELB1Mwegp0C16cFD65mbW5Ah32D4Q=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    [ "-s" "-w" "-X github.com/stern/stern/cmd.version=${version}" ];

  postInstall =
    let stern = if isCrossBuild then buildPackages.stern else "$out";
    in
    ''
      for shell in bash zsh; do
        ${stern}/bin/stern --completion $shell > stern.$shell
        installShellCompletion stern.$shell
      done
    '';

  meta = with lib; {
    description = "Multi pod and container log tailing for Kubernetes";
    homepage = "https://github.com/stern/stern";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbode preisschild ];
    platforms = platforms.unix;
  };
}
