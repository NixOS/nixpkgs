{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  iproute2,
  iptables,
  tailscale,
  versionCheckHook,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "hydrascale";
  version = "1.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Crank-Git";
    repo = "Hydrascale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXsxZOb5EAXfEuNcCs9313JeotU6kOMsMKXFJN1vHpM=";
  };

  vendorHash = "sha256-TlmP0o6nbL93HPi0a3AxENzQoBHKNJE+sUX89a6xPUU=";

  env.CGO_ENABLED = "0";

  subPackages = [ "cmd/hydrascale" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # the daemon shells out to ip, iptables, tailscale and tailscaled; suffix so
  # the system's own tailscale wins when there is one
  postInstall = ''
    wrapProgram $out/bin/hydrascale \
      --suffix PATH : ${
        lib.makeBinPath [
          iproute2
          iptables
          tailscale
        ]
      }
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hydrascale \
      --bash <($out/bin/hydrascale completion bash) \
      --fish <($out/bin/hydrascale completion fish) \
      --zsh <($out/bin/hydrascale completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run multiple Tailscale tailnets simultaneously on one Linux host";
    longDescription = ''
      Hydrascale runs one tailscaled per tailnet, each inside its own network
      namespace, and reconciles the host toward a declarative YAML config. It
      handles host routes, per-tailnet MagicDNS, local reachability rules and
      Headscale control servers.
    '';
    homepage = "https://github.com/Crank-Git/Hydrascale";
    changelog = "https://github.com/Crank-Git/Hydrascale/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "hydrascale";
  };
})
