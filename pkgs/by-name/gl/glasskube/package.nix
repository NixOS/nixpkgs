{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "0.26.1";
  gitSrc = fetchFromGitHub {
    owner = "glasskube";
    repo = "glasskube";
    tag = "v${version}";
    hash = "sha256-M/7qfr4gpogx7cr7zh/MARZME3/4ePjVUVcjG85Ona0=";
  };
  web-bundle = buildNpmPackage {
    inherit version;
    pname = "glasskube-web-bundle";

    src = gitSrc;

    npmDepsHash = "sha256-1+ROYamu0FHed6x2Y+88P0ntR8aJdN1d2UBqMBfpmyw=";

    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv internal/web/root/static/bundle $out

      runHook postInstall
    '';
  };

in
buildGoModule rec {
  inherit version;
  pname = "glasskube";

  src = gitSrc;

  vendorHash = "sha256-0cTW01f9yputdqLvpfISaS50Jeolh12OTP+NjsgXncA=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glasskube/glasskube/internal/config.Version=${version}"
    "-X github.com/glasskube/glasskube/internal/config.Commit=${src.rev}"
  ];

  subPackages = [
    "cmd/glasskube"
    "cmd/package-operator"
  ];

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preBuild = ''
    cp -r ${web-bundle}/bundle internal/web/root/static/bundle
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Completions
    installShellCompletion --cmd glasskube \
      --bash <($out/bin/glasskube completion bash) \
      --fish <($out/bin/glasskube completion fish) \
      --zsh <($out/bin/glasskube completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Missing Package Manager for Kubernetes featuring a GUI and a CLI";
    homepage = "https://github.com/glasskube/glasskube";
    changelog = "https://github.com/glasskube/glasskube/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ jakuzure ];
    license = lib.licenses.asl20;
    mainProgram = "glasskube";
  };
}
