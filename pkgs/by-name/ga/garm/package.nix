{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  npm-lockfile-fix,
  stdenv,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "garm";
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloudbase";
    repo = "garm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UAyS01NrvmTHWo603ICbsyxHpqWyLqPf8kppVrtwQPI=";
    # Add missing hashes to the lockfile, required by fetchNpmDeps.
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/webapp/package-lock.json
    '';
  };

  vendorHash = null;

  subPackages = [
    "cmd/garm"
    "cmd/garm-cli"
  ];

  postPatch = ''
    cp -r ${finalAttrs.passthru.webapp}/. webapp/assets/
  '';

  ldflags = [
    "-s"
    "-X github.com/cloudbase/garm/util/appdefaults.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$(mktemp -d)
    for shell in bash fish zsh; do
      $out/bin/garm-cli completion $shell > "garm-cli.$shell"
    done
    installShellCompletion --cmd garm-cli garm-cli.{bash,fish,zsh}
  '';

  passthru = {
    webapp = buildNpmPackage {
      pname = "garm-webapp";
      inherit (finalAttrs) version;
      src = "${finalAttrs.src}/webapp";
      npmDepsHash = "sha256-tWMkfK4k+kOv0OEyxNkxNln08fXEyQdNmpetKm55wFE=";
      installPhase = ''
        runHook preInstall
        cp -r build $out
        runHook postInstall
      '';
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "webapp"
      ];
    };

    tests = {
      inherit (nixosTests) garm-incus;
    };
  };

  meta = {
    description = "Multi-cloud, auto-scaling manager for GitHub Actions & Gitea self-hosted runners with pluggable providers";
    homepage = "https://github.com/cloudbase/garm";
    changelog = "https://github.com/cloudbase/garm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "garm";
  };
})
