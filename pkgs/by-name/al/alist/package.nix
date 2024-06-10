{
  lib,
  alist,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  fuse,
  go,
  stdenv,
  installShellFiles,
  testers,
}:
buildGoModule rec {
  pname = "alist";
  version = "3.35.0";

  src = fetchFromGitHub {
    owner = "alist-org";
    repo = "alist";
    rev = "v${version}";
    hash = "sha256-N9WgaPzc8cuDN7N0Ny3t6ARGla0lCluzF2Mut3Pg880=";
  };

  CGO_ENABLED = 1;

  vendorHash = "sha256-lZIM1Cy3JmcrnxC+HN9Ni7P70yVR1LtHVKe3nOhA4fg=";

  web = fetchurl {
    url = "https://github.com/alist-org/alist-web/releases/download/${version}/dist.tar.gz";
    hash = "sha256-lAYIwrn2TPWFrU0kFUXl8eWeX25U746iycOimZgxP8c=";
  };

  buildInputs = [ fuse ];
  tags = [ "jsoniter" ];

  ldflags = [
    "-s"
    "-w"
    "-X \"github.com/alist-org/alist/v3/internal/conf.GitAuthor=Xhofe <i@nn.ci>\""
    # time should not be used as the input for nix, instead use "Nix" as a placeholder.
    "-X github.com/alist-org/alist/v3/internal/conf.BuiltAt=Nix"
    "-X github.com/alist-org/alist/v3/internal/conf.GoVersion=${go.version}"
    "-X github.com/alist-org/alist/v3/internal/conf.GitCommit=${version}"
    "-X github.com/alist-org/alist/v3/internal/conf.Version=${version}"
    "-X github.com/alist-org/alist/v3/internal/conf.WebVersion=${version}"
  ];

  preConfigure = ''
    # build sandbox do not provide network
    rm pkg/aria2/rpc/client_test.go pkg/aria2/rpc/call_test.go

    # use matched web files
    rm -rf public/dist
    cp ${web} dist.tar.gz
    tar -xzf dist.tar.gz
    mv -f dist public
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd alist \
      --bash <($out/bin/alist completion bash) \
      --fish <($out/bin/alist completion fish) \
      --zsh <($out/bin/alist completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = alist;
      command = "${lib.getExe alist} version";
    };
  };

  meta = {
    description = "A file list/WebDAV program that supports multiple storages";
    homepage = "https://github.com/alist-org/alist";
    changelog = "https://github.com/alist-org/alist/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "alist";
  };
}
