{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "semaphore";
  version = "2.19.17";

  src = fetchFromGitHub {
    owner = "semaphoreui";
    repo = "semaphore";
    rev = "f8cefe62da4d40e536323e3dd936eb2e04e82b1a";
    hash = "sha256-qW+sxfKKJGM4Jqmz7gBXL3U45w/2rglwjiBRMAnINTY=";
  };

  vendorHash = "sha256-8/8JxWk/H6E7qVVwkWoplZP7NX1g6vEw+UFe3G0YUlc=";

  subPackages = [ "cli" ];

  tags = [ "netgo" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/semaphoreui/semaphore/util.Ver=${finalAttrs.version}"
    "-X=github.com/semaphoreui/semaphore/util.Commit=${finalAttrs.src.rev}"
    "-X=github.com/semaphoreui/semaphore/util.Date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  env.CGO_ENABLED = 0;

  frontend = buildNpmPackage {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/web";

    npmDepsHash = "sha256-4f/u2ui/zjYxZHfxuSk3eUM3mFBPubkSKKSFFnC2eW8=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall

      npm run build -- --dest dist

      mkdir -p $out
      cp -r dist/. $out/

      runHook postInstall
    '';
  };

  preBuild = ''
    mkdir -p api/public
    cp -r ${finalAttrs.frontend}/. api/public/
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/semaphore

    installShellCompletion --cmd semaphore \
      --bash <($out/bin/semaphore completion bash) \
      --fish <($out/bin/semaphore completion fish) \
      --zsh <($out/bin/semaphore completion zsh)
  '';

  passthru = {
    inherit (finalAttrs) frontend;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern UI and powerful API for Ansible, Terraform, OpenTofu, PowerShell and other DevOps tools";
    homepage = "https://semaphoreui.com/";
    changelog = "https://github.com/semaphoreui/semaphore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "semaphore";
    maintainers = with lib.maintainers; [ vysakh ];
    platforms = lib.platforms.unix;
  };
})
