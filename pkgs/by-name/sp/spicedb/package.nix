{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.46.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    tag = "v${version}";
    hash = "sha256-NQLQeZxHGznQhOwjskmIIoYvoO6YNPMm6jnMUFmlj0Q=";
  };

  vendorHash = "sha256-avgczuZlXmhrycf0v7kXy9GuxKDkvcfiJCu+sW3/tz8=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.tag}'"
  ];

  subPackages = [ "cmd/spicedb" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
