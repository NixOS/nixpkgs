{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "spicedb";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kKdBS9Rl0nHRE3Nv/B5KF8SRlG4dnGmpVt8qaE3idMI=";
  };

  vendorHash = "sha256-9VWTJyAOJD7YivzNcVOYYF3eWnR7Fhb/neSVx9pNM7g=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${finalAttrs.src.tag}'"
  ];

  subPackages = [ "cmd/spicedb" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd spicedb \
      --bash <($out/bin/spicedb completion bash) \
      --fish <($out/bin/spicedb completion fish) \
      --zsh <($out/bin/spicedb completion zsh)
  '';

  meta = {
    changelog = "https://github.com/authzed/spicedb/releases/tag/${finalAttrs.src.tag}";
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      squat
      thoughtpolice
    ];
    mainProgram = "spicedb";
  };
})
