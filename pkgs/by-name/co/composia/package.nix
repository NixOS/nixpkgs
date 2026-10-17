{
  lib,
  buildGoModule,
  fetchFromForgejo,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "composia";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.alexma.top";
    owner = "alexma233";
    repo = "composia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K6ZOxZIqHqHrFWtZbCImr7oL2xL8HthUdUuyUazZvJo=";
  };

  vendorHash = "sha256-UlcjyE6WnHnb0x0yPqpgEoCUD1Rsi/M1IBukp/Z3siI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/composia"
    "cmd/composia-controller"
    "cmd/composia-agent"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X forgejo.alexma.top/alexma233/composia/internal/version.Value=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm644 packaging/systemd/composia-agent.service "$out/lib/systemd/system/composia-agent.service"
    install -Dm644 packaging/systemd/composia-controller.service "$out/lib/systemd/system/composia-controller.service"
    substituteInPlace "$out/lib/systemd/system/composia-agent.service" \
      --replace-fail /usr/bin/composia-agent "$out/bin/composia-agent"
    substituteInPlace "$out/lib/systemd/system/composia-controller.service" \
      --replace-fail /usr/bin/composia-controller "$out/bin/composia-controller"

    installShellCompletion --cmd composia \
      --bash <("$out/bin/composia" completion bash) \
      --zsh <("$out/bin/composia" completion zsh) \
      --fish <("$out/bin/composia" completion fish)
  '';

  meta = {
    description = "Self-hosted Docker Compose control plane and CLI";
    homepage = "https://docs.composia.xyz";
    changelog = "https://forgejo.alexma.top/alexma233/composia/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ alexma233 ];
    mainProgram = "composia";
    platforms = lib.platforms.linux;
  };
})
