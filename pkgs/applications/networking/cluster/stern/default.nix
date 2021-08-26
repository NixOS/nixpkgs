{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:
let isCrossBuild = stdenv.hostPlatform != stdenv.buildPlatform;

in
buildGoModule rec {
  pname = "stern";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-y8FkQBZHg4LYC8CmwQSg2oZjIrlY30tL/OkfnT+XsMM=";
  };

  vendorSha256 = "sha256-217OKXT072hpq4a6JEev4rSR8uUoPdDbOR7KUkhpM9E=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray =
    [ "-ldflags=-s -w -X github.com/stern/stern/cmd.version=${version}" ];

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
