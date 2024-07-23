{ lib
, buildGoModule
, fetchFromGitHub
, gnused
, installShellFiles
, nixosTests
, caddy
, testers
, stdenv
}:
let
  attrsToModule = map (plugin: plugin.repo);
  attrsToVersionedModule = map ({ repo, version, ... }: lib.escapeShellArg "${repo}@${version}");

  pname = "caddy";
  version = "2.8.4";

  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    hash = "sha256-O4s7PhSUTXoNEIi+zYASx8AgClMC5rs7se863G6w+l0=";
  };

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
    hash = "sha256-CBfyqtWp3gYsYwaIxbfXO3AYaBiM7LutLC7uZgYXfkQ=";
  };

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  # matches upstream since v2.8.0
  tags = [ "nobadger" ];

  nativeBuildInputs = [ gnused installShellFiles ];

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

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    mainProgram = "caddy";
    maintainers = with maintainers; [ Br1ght0ne emilylange techknowlogick ];
  };
in
buildGoModule {
  inherit
    pname
    version
    src
    subPackages
    ldflags
    tags
    nativeBuildInputs
    postInstall
    meta
    ;

  vendorHash = "sha256-1Api8bBZJ1/oYk4ZGIiwWCSraLzK9L+hsKXkFtk6iVM=";

  passthru = {
    withPlugins =
      {
        caddyModules,
        vendorHash ? lib.fakeHash,
      }:
      buildGoModule {
        pname = "${caddy.pname}-with-plugins";

        inherit
          version
          src
          subPackages
          ldflags
          tags
          nativeBuildInputs
          postInstall
          meta
          ;

        modBuildPhase = ''
          for module in ${toString (attrsToModule caddyModules)}; do
            sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
          done
          for plugin in ${toString (attrsToVersionedModule caddyModules)}; do
            go get $plugin
          done
          go mod vendor
        '';

        modInstallPhase = ''
          mv -t vendor go.mod go.sum
          cp -r vendor "$out"
        '';

        preBuild = ''
          chmod -R u+w vendor
          [ -f vendor/go.mod ] && mv -t . vendor/go.{mod,sum}
          for module in ${toString (attrsToModule caddyModules)}; do
            sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
          done
        '';

        inherit vendorHash;
      };
    tests = {
      inherit (nixosTests) caddy;
      version = testers.testVersion {
        command = "${caddy}/bin/caddy version";
        package = caddy;
      };
    };
  };
}
