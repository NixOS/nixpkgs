{ lib
, buildGoModule
, fetchFromGitHub
, gnused
, nixosTests
, caddy
, testers
, installShellFiles
, stdenv
, externalPlugins ? [ ]
, vendorHash ? "sha256-1Api8bBZJ1/oYk4ZGIiwWCSraLzK9L+hsKXkFtk6iVM="
}:
let
  attrsToModules = map (plugin: plugin.repo);
  attrsToSources = map ({ repo, version, ... }: lib.escapeShellArg "${repo}@${version}");
  version = "2.8.4";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    hash = "sha256-O4s7PhSUTXoNEIi+zYASx8AgClMC5rs7se863G6w+l0=";
  };
in
buildGoModule {
  pname = "caddy";
  inherit version;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
    hash = "sha256-CBfyqtWp3gYsYwaIxbfXO3AYaBiM7LutLC7uZgYXfkQ=";
  };

  inherit vendorHash;

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  # matches upstream since v2.8.0
  tags = [ "nobadger" ];

  nativeBuildInputs = [ gnused installShellFiles ];

  modBuildPhase = ''
    for module in ${toString (attrsToModules externalPlugins)}; do
      sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
    done
    for plugin in ${toString (attrsToSources externalPlugins)}; do
      go get $plugin
    done

    go generate
    go mod vendor
  '';

  modInstallPhase = ''
    mv -t vendor go.mod go.sum
    cp -r vendor "$out"
  '';

  preBuild = ''
    chmod -R u+w vendor
    [ -f vendor/go.mod ] && mv -t . vendor/go.{mod,sum}
    go generate

    for module in ${toString (attrsToModules externalPlugins)}; do
      sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
    done
  '';

  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Generating man pages and completions fail on cross-compilation
    # https://github.com/NixOS/nixpkgs/issues/308283

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

    installShellCompletion --cmd caddy \
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) caddy;
    version = testers.testVersion {
      command = "${caddy}/bin/caddy version";
      package = caddy;
    };
  };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    mainProgram = "caddy";
    maintainers = with maintainers; [ Br1ght0ne emilylange techknowlogick ];
  };
}
