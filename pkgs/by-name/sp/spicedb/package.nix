{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.45.3";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    tag = "v${version}";
    hash = "sha256-V+JYWoZclA4agfqXl3oUhxdTlJXeuO3JQIPfqu2idy0=";
  };

  vendorHash = "sha256-hr+xIfPjlrH9igRsYeqNOPgx/jWhDfu73gA+/NoWWxI=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.tag}'"
  ];

  subPackages = [ "cmd/spicedb" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd spicedb \
      --bash <($out/bin/spicedb completion bash) \
      --fish <($out/bin/spicedb completion fish) \
      --zsh <($out/bin/spicedb completion zsh)
  '';

  meta = with lib; {
    changelog = "https://github.com/authzed/spicedb/releases/tag/${src.tag}";
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      squat
      thoughtpolice
    ];
    mainProgram = "spicedb";
  };
}
