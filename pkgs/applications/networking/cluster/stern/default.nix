{ stdenv, lib, buildPackages, buildGoModule, fetchFromGitHub, installShellFiles }:
let isCrossBuild = stdenv.hostPlatform != stdenv.buildPlatform;

in
buildGoModule rec {
  pname = "stern";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    sha256 = "sha256-jgmURvc1did3YgtqWlAzFbWxc3jHHylOfCVOLeAC7V8=";
  };

  vendorSha256 = "sha256-p8WoFDwABXcO54WKP5bszoht2JdjHlRJjbG8cMyNo6A=";

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
