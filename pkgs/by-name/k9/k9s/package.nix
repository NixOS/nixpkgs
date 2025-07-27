{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  k9s,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "k9s";
  version = "0.50.9";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wTQOBxJgrDPcWSiezCwHNgvfGa6oWBM+DNa7RC/9PJA=";
  };

  ldflags = [
    "-s"
    "-X github.com/derailed/k9s/cmd.version=${finalAttrs.version}"
    "-X github.com/derailed/k9s/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/derailed/k9s/cmd.date=1970-01-01T00:00:00Z"
  ];

  tags = [ "netcgo" ];

  proxyVendor = true;

  vendorHash = "sha256-SDl47tAYiE00gFpCvoBeiV8XL/E29457b1RQW3pogmM=";

  # TODO investigate why some config tests are failing
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  # For arch != x86
  # {"level":"fatal","error":"could not create any of the following paths: /homeless-shelter/.config, /etc/xdg","time":"2022-06-28T15:52:36Z","message":"Unable to create configuration directory for k9s"}
  passthru = {
    tests.version = testers.testVersion {
      package = k9s;
      command = "HOME=$(mktemp -d) k9s version -s";
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    # k9s requires a writeable log directory
    # Otherwise an error message is printed
    # into the completion scripts
    export K9S_LOGS_DIR=$(mktemp -d)

    installShellCompletion --cmd k9s \
      --bash <($out/bin/k9s completion bash) \
      --fish <($out/bin/k9s completion fish) \
      --zsh <($out/bin/k9s completion zsh)

    mkdir -p $out/share/k9s/skins
    cp -r $src/skins/* $out/share/k9s/skins/
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  meta = {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    changelog = "https://github.com/derailed/k9s/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "k9s";
    maintainers = with lib.maintainers; [
      Gonzih
      markus1189
      bryanasdev000
      qjoly
      devusb
      ryan4yin
    ];
  };
})
