{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, buildGoModule
, systemd
, yarn
, fixup-yarn-lock
, nodejs
, grafana-alloy
, nix-update-script
, testers
}:

buildGoModule rec {
  pname = "grafana-alloy";
  version = "1.0.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "alloy";
    hash = "sha256-G+lLxdUnE07QXt2wBcS6K3DVHIS35aKCh0TZCzpNgBE=";
  };

  vendorHash = "sha256-Dj3K0ynPPl350tNYClZDHNNan54N1iGfnryH60nO1bg=";

  nativeBuildInputs = [ fixup-yarn-lock yarn nodejs ];

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

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/internal/web/ui/yarn.lock";
    sha256 = "sha256-WqbIg18qUNcs9O2wh7DAzwXKb60iEuPL8zFCIgScqI0=";
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
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isLinux [ "-I${lib.getDev systemd}/include" ];

  checkFlags = [
    "-tags nonetwork" # disable network tests
    "-tags nodocker" # disable docker tests
  ];

  # go-systemd uses libsystemd under the hood, which does dlopen(libsystemd) at
  # runtime.
  # Add to RUNPATH so it can be found.
  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath [ (lib.getLib systemd) ]}:$(patchelf --print-rpath $out/bin/alloy)" \
      $out/bin/alloy
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        version = "v${version}";
        command = "${lib.getExe grafana-alloy} --version";
        package = grafana-alloy;
      };
    };
    updateScript = nix-update-script { };
    # alias for nix-update to be able to find and update this attribute
    offlineCache = yarnOfflineCache;
  };

  meta = with lib; {
    description = "Open source OpenTelemetry Collector distribution with built-in Prometheus pipelines and support for metrics, logs, traces, and profiles";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/alloy";
    maintainers = with maintainers; [ flokli emilylange ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
