{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGo127Module,
  buildNpmPackage,
  systemdLibs,
  installShellFiles,
  versionCheckHook,
  nixosTests,
  lld,
  useLLD ? stdenv.hostPlatform.isArmv7,
  withBeyla ?
    stdenv.targetPlatform.system == "x86_64-linux" || stdenv.targetPlatform.system == "aarch64-linux",
}:
buildGo127Module (finalAttrs: {
  pname = "grafana-alloy";
  version = "1.21.2";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "alloy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9TUFOcDITpC86/Fe+tbPzIp6Q3D117qVEhb29zkRR8E=";
  };

  postUnpack = lib.optionalString withBeyla (
    let
      inherit (stdenv.targetPlatform) system;
      arch =
        {
          x86_64-linux = "amd64";
          aarch64-linux = "arm64";
        }
        .${system} or (throw "Unsupported system: ${system}");
      beyla = builtins.fromJSON (builtins.readFile ./beyla.json);
    in
    ''
      tar -xf ${
        fetchurl { inherit (beyla.${arch}) url hash; }
      } -C source/internal/component/beyla/ebpf/binaries/${arch} beyla
    ''
  );

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/internal/web/ui";
    hash = "sha256-rUXEnlgIr+YuQI1abqoUmJMFoYpl41snjbhXVeZNCaU=";
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

    # Use only the system CA store. The embedded fallback bundle does not get cacert updates.
    substituteInPlace flowcmd/flowcmd.go \
      --replace-fail '_ "golang.org/x/crypto/x509roots/fallback"' ""
  '';

  modRoot = "collector";

  proxyVendor = true;
  vendorHash = "sha256-PvTmwj4YsOjrvB8JmgT5B+Yt9GuwTpk53hYl3OW+2e0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grafana/alloy/internal/build.Version=${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.Branch=v${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.Revision=v${finalAttrs.version}"
    "-X github.com/grafana/alloy/internal/build.BuildUser=nix@nixpkgs"
    "-X github.com/grafana/alloy/internal/build.BuildDate=1970-01-01T00:00:00Z"
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
      NIX_CFLAGS_COMPILE = "-I${lib.getDev systemdLibs}/include";
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
        lib.makeLibraryPath [ (lib.getLib systemdLibs) ]
      }:$(patchelf --print-rpath $out/bin/alloy)" \
      $out/bin/alloy
  '';

  passthru = {
    tests = {
      inherit (nixosTests) alloy;
    };
    updateScript = ./update.sh;
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
