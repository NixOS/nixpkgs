{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  nixosTests,
  caddy,
  testers,
  installShellFiles,
  stdenv,
}:
let
  version = "2.9.1";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    tag = "v${version}";
    hash = "sha256-28ahonJ0qeynoqf02gws0LstaL4E08dywSJ8s3tgEDI=";
  };
in
buildGoModule {
  pname = "caddy";
  inherit version;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    tag = "v${version}";
    hash = "sha256-XW1cBW7mk/aO/3IPQK29s4a6ArSKjo7/64koJuzp07I=";
  };

  vendorHash = "sha256-qrlpuqTnFn/9oMTMovswpS1eAI7P9gvesoMpsIWKcY8=";

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  # matches upstream since v2.8.0
  tags = [
    "nobadger"
    "nomysql"
    "nopgx"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    ''
      install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

      substituteInPlace $out/lib/systemd/system/caddy.service \
        --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
      substituteInPlace $out/lib/systemd/system/caddy-api.service \
        --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      # Generating man pages and completions fail on cross-compilation
      # https://github.com/NixOS/nixpkgs/issues/308283

      $out/bin/caddy manpage --directory manpages
      installManPage manpages/*

      installShellCompletion --cmd caddy \
        --bash <($out/bin/caddy completion bash) \
        --fish <($out/bin/caddy completion fish) \
        --zsh <($out/bin/caddy completion zsh)
    '';

  passthru = {
    tests = {
      inherit (nixosTests) caddy;
      version = testers.testVersion {
        command = "${caddy}/bin/caddy version";
        package = caddy;
      };
      acme-integration = nixosTests.acme.caddy;
    };
    withPlugins = callPackage ./plugins.nix { inherit caddy; };
  };

  meta = {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = lib.licenses.asl20;
    mainProgram = "caddy";
    maintainers = with lib.maintainers; [
      Br1ght0ne
      stepbrobd
      techknowlogick
    ];
  };
}
