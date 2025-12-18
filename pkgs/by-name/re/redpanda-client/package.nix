{
  buildGoModule,
  doCheck ? !stdenv.hostPlatform.isDarwin, # Can't start localhost test server in MacOS sandbox.
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
let
  version = "25.3.2";
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "redpanda";
    rev = "v${version}";
    sha256 = "sha256-mUIFPTh1VgXOfD6te0uHrhdGs00J0Hu6MXcR3g/6cZ8=";
  };
in
buildGoModule rec {
  pname = "redpanda-rpk";
  inherit doCheck src version;
  modRoot = "./src/go/rpk";
  runVend = false;
  vendorHash = "sha256-N/UCN0U/vTfYq91m3ehhtRvNxeoaGsLYQtnBUUZsU5U=";

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

  meta = {
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      avakhrenev
      happysalada
    ];
    platforms = lib.platforms.all;
    mainProgram = "rpk";
  };
}
