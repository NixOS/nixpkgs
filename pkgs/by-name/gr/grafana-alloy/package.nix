{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  buildNpmPackage,
  systemd,
  installShellFiles,
  versionCheckHook,
  nixosTests,
  nix-update-script,
  lld,
  useLLD ? stdenv.hostPlatform.isArmv7,
}:

let
  beylaVersion = "v3.9.5";
in

buildGoModule (finalAttrs: {
  pname = "grafana-alloy";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "alloy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q5R2noxBZ3OPyZqmB+bx3iJKWFxC2WIprcgh9RwjLzk=";
  };

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/internal/web/ui";
    hash = "sha256-vResNUT4auDsK9ngnJYfMUUOYr/ikPhrvakqCjGq2Q8=";
  };

  frontend = buildNpmPackage {
    pname = "alloy-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/internal/web/ui";

    inherit (finalAttrs) npmDeps;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -av dist $out/share

      runHook postInstall
    '';
  };

  patchPhase = ''
    cp -av ${finalAttrs.frontend}/share internal/web/ui/dist

    goSumBeylaVersion="$(grep beyla go.sum | head -1 | cut -d ' ' -f2)"
    if [[ "$goSumBeylaVersion" != "${beylaVersion}" ]];then
      echo "beyla version in go.sum ($goSumBeylaVersion) doesn't match the one set in the expression (${beylaVersion}), needs updating."
      exit 1
    fi
  '';

  modRoot = "collector";

  proxyVendor = true;
  vendorHash = "sha256-uTIdurwLfxh27fb1CPCHbHmENk3S6VYNBaGT/5yh3Sc=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grafana/alloy/internal/build.Version=${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.Branch=v${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.Revision=v${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.BuildUser=nix@nixpkgs"
    "-X github.com/grafana/alloy/internal/build.BuildDate=1970-01-01T00:00:00Z"
    "-X github.com/grafana/beyla/pkg/buildinfo=${beylaVersion}"
  ];

  tags = [
    "embedalloyui"
    "gore2regex"
    "netgo"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "promtail_journal_enabled"
  ];

  env =
    lib.optionalAttrs useLLD {
      NIX_CFLAGS_LINK = "-fuse-ld=lld";
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isLinux) {
      # Uses go-systemd, which uses libsystemd headers.
      # https://github.com/coreos/go-systemd/issues/351
      NIX_CFLAGS_COMPILE = "-I${lib.getDev systemd}/include";
    };

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals useLLD [ lld ];

  postInstall =
    "mv -v $out/bin/otel_engine $out/bin/alloy"
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''

      installShellCompletion --cmd alloy \
        --bash <($out/bin/alloy completion bash) \
        --fish <($out/bin/alloy completion fish) \
        --zsh <($out/bin/alloy completion zsh)
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  # go-systemd uses libsystemd under the hood, which does dlopen(libsystemd) at
  # runtime. Add to RPATH so it can be found.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-rpath "${
        lib.makeLibraryPath [ (lib.getLib systemd) ]
      }:$(patchelf --print-rpath $out/bin/alloy)" \
      $out/bin/alloy
  '';

  passthru = {
    tests = {
      inherit (nixosTests) alloy;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(.+)"
      ];
    };
    # For nix-update to be able to find and update the hash.
    inherit (finalAttrs) npmDeps;
  };

  meta = {
    description = "OpenTelemetry Collector distribution with programmable pipelines";
    longDescription = ''
      Grafana Alloy is an open source OpenTelemetry Collector distribution with
      built-in Prometheus pipelines and support for metrics, logs, traces, and
      profiles.
    '';
    homepage = "https://grafana.com/oss/alloy";
    changelog = "https://github.com/grafana/alloy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      azahi
      flokli
      hbjydev
    ];
    mainProgram = "alloy";
  };
})
