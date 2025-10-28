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
buildGoModule rec {
  pname = "headscale";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    tag = "v${version}";
    hash = "sha256-LnS6K3U4RgRRV4i92zcRZtLJF1QdbORQP9ZIis9u6rk=";
  };

  vendorHash = "sha256-dR8xmUIDMIy08lhm7r95GNNMAbXv4qSH3v9HR40HlNk=";

  subPackages = [ "cmd/headscale" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juanfont/headscale/cmd/headscale/cli.Version=v${version}"
  ];

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

  meta = with lib; {
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
    license = licenses.bsd3;
    mainProgram = "headscale";
    maintainers = with maintainers; [
      kradalby
      misterio77
    ];
  };
}
