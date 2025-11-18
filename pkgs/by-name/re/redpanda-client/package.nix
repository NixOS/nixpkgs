{
  buildGoModule,
  doCheck ? !stdenv.hostPlatform.isDarwin, # Can't start localhost test server in MacOS sandbox.
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
let
  version = "25.2.11";
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "redpanda";
    rev = "v${version}";
    sha256 = "sha256-MOfQ/7aCbC5zdEB+hyIAgbRLfpSdSIjKigfUPTSqqr8=";
  };
in
buildGoModule rec {
  pname = "redpanda-rpk";
  inherit doCheck src version;
  modRoot = "./src/go/rpk";
  runVend = false;
  vendorHash = "sha256-N9RZ5qRbh8B0g+A3UUutOnAeob0eR2jO9kmrlADT0iQ=";

  ldflags = [
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.version=${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.rev=v${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/container/common.tag=v${version}"''
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/rpk generate shell-completion $shell > rpk.$shell
      installShellCompletion rpk.$shell
    done
  '';

  meta = with lib; {
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      avakhrenev
      happysalada
    ];
    platforms = platforms.all;
    mainProgram = "rpk";
  };
}
