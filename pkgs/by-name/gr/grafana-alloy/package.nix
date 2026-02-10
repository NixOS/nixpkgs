{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  buildNpmPackage,
  systemd,
  grafana-alloy,
  nixosTests,
  nix-update-script,
  installShellFiles,
  testers,
  lld,
  useLLD ? stdenv.hostPlatform.isArmv7,
}:

buildGoModule (finalAttrs: rec {
  pname = "grafana-alloy";
  version = "1.12.2";
  src = fetchFromGitHub {
    owner = "grafana";
    repo = "alloy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C/yqsUjEwKnGRkxMOQkKfGdeERbvO/e7D7c3CyJ+cVY=";
  };

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/internal/web/ui";
    hash = "sha256-3J1Slka5bi+72NUaHBmDTtG1faJWRkOlkClKnUyiUsk=";
  };

  frontend = buildNpmPackage {
    pname = "alloy-frontend";
    inherit version src;

    inherit npmDeps;
    sourceRoot = "${src.name}/internal/web/ui";

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -av dist $out/share

      runHook postInstall
    '';
  };

  proxyVendor = true;
  vendorHash = "sha256-Bq/6ld2LldSDhksNqGMHXZAeNHh74D07o2ETpQqMcP4=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals useLLD [ lld ];

  env =
    lib.optionalAttrs useLLD {
      NIX_CFLAGS_LINK = "-fuse-ld=lld";
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux) {
      # uses go-systemd, which uses libsystemd headers
      # https://github.com/coreos/go-systemd/issues/351
      NIX_CFLAGS_COMPILE = "-I${lib.getDev systemd}/include";
    };

  ldflags =
    let
      prefix = "github.com/grafana/alloy/internal/build";
    in
    [
      "-s"
      "-w"
      # https://github.com/grafana/alloy/blob/3201389252d2c011bee15ace0c9f4cdbcb978f9f/Makefile#L110
      "-X ${prefix}.Branch=v${finalAttrs.version}"
      "-X ${prefix}.Version=${finalAttrs.version}"
      "-X ${prefix}.Revision=v${finalAttrs.version}"
      "-X ${prefix}.BuildUser=nix"
      "-X ${prefix}.BuildDate=1970-01-01T00:00:00Z"
    ];

  tags = [
    "netgo"
    "builtinassets"
    "promtail_journal_enabled"
  ];

  patchPhase = ''
    # Copy frontend build in
    cp -va "${frontend}/share" "internal/web/ui/dist"
  '';

  subPackages = [
    "."
  ];

  checkFlags = [
    "-tags"
    "nonetwork" # disable network tests
    "-tags"
    "nodocker" # disable docker tests
  ];

  # go-systemd uses libsystemd under the hood, which does dlopen(libsystemd) at
  # runtime.
  # Add to RUNPATH so it can be found.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-rpath "${
        lib.makeLibraryPath [ (lib.getLib systemd) ]
      }:$(patchelf --print-rpath $out/bin/alloy)" \
      $out/bin/alloy
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd alloy \
      --bash <($out/bin/alloy completion bash) \
      --fish <($out/bin/alloy completion fish) \
      --zsh <($out/bin/alloy completion zsh)
  '';

  passthru = {
    tests = {
      inherit (nixosTests) alloy;
      version = testers.testVersion {
        version = "v${finalAttrs.version}";
        package = grafana-alloy;
      };
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(.+)"
      ];
    };
    # for nix-update to be able to find and update the hash
    inherit npmDeps;
  };

  meta = {
    description = "Open source OpenTelemetry Collector distribution with built-in Prometheus pipelines and support for metrics, logs, traces, and profiles";
    mainProgram = "alloy";
    license = lib.licenses.asl20;
    homepage = "https://grafana.com/oss/alloy";
    changelog = "https://github.com/grafana/alloy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      azahi
      flokli
      hbjydev
    ];
    platforms = lib.platforms.unix;
  };
})
