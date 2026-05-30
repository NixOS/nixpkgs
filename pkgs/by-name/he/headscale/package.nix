{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  iana-etc,
  libredirect,
  nixosTests,
  postgresql,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "headscale";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gR5kOFv4/+87mOhMYjejBMhZlrwYhABZpG0zjIL5vtI=";
  };

  postPatch = ''
    substituteInPlace hscontrol/types/version.go \
      --replace-fail 'Version:   "dev"' 'Version: "${finalAttrs.version}"' \
      --replace-fail 'Commit:    "unknown"' 'Commit: "${finalAttrs.src.tag}"'
  '';

  vendorHash = "sha256-jkeB9XUTEGt58fPOMpE4/e3+JQoMQTgf0RlthVBmfG0=";

  subPackages = [ "cmd/headscale" ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    libredirect.hook
    postgresql
  ];

  checkFlags = [ "-short" ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd headscale \
      --bash <($out/bin/headscale completion bash) \
      --fish <($out/bin/headscale completion fish) \
      --zsh <($out/bin/headscale completion zsh)
  '';

  passthru.tests = { inherit (nixosTests) headscale; };

  meta = {
    homepage = "https://github.com/juanfont/headscale";
    description = "Open source, self-hosted implementation of the Tailscale control server";
    longDescription = ''
      Tailscale is a modern VPN built on top of Wireguard. It works like an
      overlay network between the computers of your networks - using all kinds
      of NAT traversal sorcery.

      Everything in Tailscale is Open Source, except the GUI clients for
      proprietary OS (Windows and macOS/iOS), and the
      'coordination/control server'.

      The control server works as an exchange point of Wireguard public keys for
      the nodes in the Tailscale network. It also assigns the IP addresses of
      the clients, creates the boundaries between each user, enables sharing
      machines between users, and exposes the advertised routes of your nodes.

      Headscale implements this coordination server.
    '';
    license = lib.licenses.bsd3;
    mainProgram = "headscale";
    maintainers = with lib.maintainers; [
      kradalby
      misterio77
    ];
  };
})
