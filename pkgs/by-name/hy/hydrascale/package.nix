{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  makeWrapper,
  iproute2,
  iptables,
  procps,
  tailscale,
  versionCheckHook,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "hydrascale";
  version = "1.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Crank-Git";
    repo = "Hydrascale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t92I4zJvnZlgRgxQclSZ4unCLDZFNQ4z70lZDjE0VKg=";
  };

  # seed the namespace overlay resolv.conf and write bare hostnames to /etc/hosts, so
  # MagicDNS activates and unprefixed names resolve without systemd-resolved
  # (Crank-Git/Hydrascale#480, fixed by #481); drop when a release includes it
  patches = [
    (fetchpatch {
      name = "hydrascale-seed-resolv-conf-and-bare-hosts.patch";
      url = "https://github.com/hatch01/Hydrascale/commit/74352256d843b18fce646990251bbedd6c408db6.patch";
      excludes = [ "docs/*" ];
      hash = "sha256-ofkRArCZ1GTMyKlo2z3Tr2RCiIJWMjyaFflO0wL6xCo=";
    })
  ];

  vendorHash = "sha256-eQHU0tkhWIAqVMp9mAsD8Se53QOGdUA9rbk4QdpvpnQ=";

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

  # the daemon shells out to ip, ss, iptables, sysctl, tailscale and tailscaled; suffix so
  # the system's own tailscale wins when there is one
  postInstall = ''
    wrapProgram $out/bin/hydrascale \
      --suffix PATH : ${
        lib.makeBinPath [
          iproute2
          iptables
          procps
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
