{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  testers,
  versionCheckHook,
  git-fleet,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # Map platform to release info
    platformMap = {
      "x86_64-linux" = {
        name = "linux-amd64";
        hash = "sha256-7+0OkWxNnzj8EpzL10LnHMbhO5EF8uhzlmmL9Klfl+E=";
      };
      "aarch64-linux" = {
        name = "linux-arm64";
        hash = "sha256-hvkGRqn0Lm5Ch3L+2lcQcSO9LWmmAkIQQQ8vm+GKS88=";
      };
      "x86_64-darwin" = {
        name = "darwin-amd64";
        hash = "sha256-D4NAQBLXJSLxb4gZn4HcyRfq/hznbpCm+kzyZXQzMHo=";
      };
      "aarch64-darwin" = {
        name = "darwin-arm64";
        hash = "sha256-E/HrQ3ovhlR91Bjvq4654MzZaWYF8wdC9ChcEulsPiU=";
      };
    };

    platformInfo =
      platformMap.${stdenv.hostPlatform.system}
        or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
  in
  {
    pname = "git-fleet";
    version = "2.4.2";

    src = fetchurl {
      url = "https://github.com/qskkk/git-fleet/releases/download/v${finalAttrs.version}/git-fleet-v${finalAttrs.version}-${platformInfo.name}.tar.gz";
      hash = platformInfo.hash;
    };

    nativeBuildInputs = [
      installShellFiles
    ];

    nativeInstallCheckInputs = [
      versionCheckHook
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp gf $out/bin/
      chmod +x $out/bin/gf

      runHook postInstall
    '';

    versionCheckProgram = "${placeholder "out"}/bin/gf";
    versionCheckProgramArg = "--version";
    versionCheckPhase = ''
      runHook preInstallCheck

      $versionCheckProgram $versionCheckProgramArg

      runHook postInstallCheck
    '';
    doInstallCheck = true;

    passthru = {
      tests = {
        version = testers.testVersion {
          package = git-fleet;
          command = "gf --version";
        };
      };
    };

    meta = {
      description = "Powerful command-line tool for managing multiple Git repositories";
      longDescription = ''
        GitFleet is a high-performance command-line tool written in Go that helps
        developers efficiently manage multiple Git repositories from a single place.
        Built with concurrency in mind, GitFleet leverages Go's powerful goroutines
        to parallelize operations across repositories, dramatically reducing execution
        time for bulk operations.

        Designed for teams, DevOps engineers, and power users working across many
        projects, GitFleet excels at handling large repository fleets with
        lightning-fast parallel execution. Whether you're performing status checks,
        pulling updates, or running custom commands across hundreds of repositories,
        GitFleet's concurrent architecture ensures optimal performance and resource
        utilization.

        The tool provides both an intuitive interactive interface and powerful
        command-line operations, making it easy to coordinate complex workflows
        across distributed development environments while maintaining peak efficiency.
      '';
      homepage = "https://github.com/qskkk/git-fleet";
      changelog = "https://github.com/qskkk/git-fleet/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ qskkk ];
      mainProgram = "gf";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  }
)
