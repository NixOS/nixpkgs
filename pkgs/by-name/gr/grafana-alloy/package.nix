{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  buildGoModule,
  systemd,
  yarn,
  fixup-yarn-lock,
  nodejs,
  grafana-alloy,
  nixosTests,
  nix-update-script,
  installShellFiles,
  testers,
}:

buildGoModule rec {
  pname = "grafana-alloy";
  version = "1.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "alloy";
    hash = "sha256-uiJwzpWmViyVZRimnDP8XkTyT0v6dliyyh4rvIi0T9M=";
  };

  proxyVendor = true;
  vendorHash = "sha256-mh51vVHWq14UgfB45/HTE8Z/9t41atgoSJRPUb4jZd4=";

  nativeBuildInputs = [
    fixup-yarn-lock
    yarn
    nodejs
    installShellFiles
  ];

  ldflags =
    let
      prefix = "github.com/grafana/alloy/internal/build";
    in
    [
      "-s"
      "-w"
      # https://github.com/grafana/alloy/blob/3201389252d2c011bee15ace0c9f4cdbcb978f9f/Makefile#L110
      "-X ${prefix}.Branch=v${version}"
      "-X ${prefix}.Version=${version}"
      "-X ${prefix}.Revision=v${version}"
      "-X ${prefix}.BuildUser=nix"
      "-X ${prefix}.BuildDate=1970-01-01T00:00:00Z"
    ];

  tags = [
    "netgo"
    "builtinassets"
    "promtail_journal_enabled"
  ];

  subPackages = [
    "."
  ];

  # Skip building the frontend in the goModules FOD
  overrideModAttrs = (
    _: {
      preBuild = null;
    }
  );

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/internal/web/ui/yarn.lock";
    hash = "sha256-309e799oSBtESmsbxvBWhAC8I717U032Xe/h09xQecA=";
  };

  preBuild = ''
    pushd internal/web/ui

    # Yarn wants a real home directory to write cache, config, etc to
    export HOME=$NIX_BUILD_TOP/fake_home

    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    patchShebangs node_modules/

    yarn --offline build

    popd
  '';

  # uses go-systemd, which uses libsystemd headers
  # https://github.com/coreos/go-systemd/issues/351
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.hostPlatform.isLinux [
    "-I${lib.getDev systemd}/include"
  ];

  checkFlags = [
    "-tags nonetwork" # disable network tests
    "-tags nodocker" # disable docker tests
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

  postInstall = ''
    installShellCompletion --cmd alloy \
      --bash <($out/bin/alloy completion bash) \
      --fish <($out/bin/alloy completion fish) \
      --zsh <($out/bin/alloy completion zsh)
  '';

  passthru = {
    tests = {
      inherit (nixosTests) alloy;
      version = testers.testVersion {
        version = "v${version}";
        package = grafana-alloy;
      };
    };
    updateScript = nix-update-script { };
    # alias for nix-update to be able to find and update this attribute
    offlineCache = yarnOfflineCache;
  };

  meta = with lib; {
    description = "Open source OpenTelemetry Collector distribution with built-in Prometheus pipelines and support for metrics, logs, traces, and profiles";
    mainProgram = "alloy";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/alloy";
    changelog = "https://github.com/grafana/alloy/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [
      azahi
      flokli
      emilylange
      hbjydev
    ];
    platforms = lib.platforms.unix;
  };
}
