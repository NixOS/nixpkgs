{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, caddy
, testers
, installShellFiles
, stdenv
, go
, xcaddy
, cacert
, git
}:
let
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

  vendorHash = "sha256-1Api8bBZJ1/oYk4ZGIiwWCSraLzK9L+hsKXkFtk6iVM=";

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  # matches upstream since v2.8.0
  tags = [ "nobadger" ];

  nativeBuildInputs = [ installShellFiles ];

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

  passthru = {
    tests = {
      inherit (nixosTests) caddy;
      version = testers.testVersion {
        command = "${caddy}/bin/caddy version";
        package = caddy;
      };
    };
    withPlugins =
      { plugins
      , hash ? lib.fakeHash
      }: caddy.overrideAttrs (finalAttrs: prevAttrs:
      let
        pluginsSorted = builtins.sort builtins.lessThan plugins;
        pluginsList = lib.concatMapStrings (plugin: "${plugin}-") pluginsSorted;
        pluginsHash = builtins.hashString "md5" pluginsList;
        pluginsWithoutVersion = builtins.filter (p: !lib.hasInfix "@" p) pluginsSorted;
      in
      assert lib.assertMsg (builtins.length pluginsWithoutVersion == 0)
        "All plugins should have a version (eg ${builtins.elemAt pluginsWithoutVersion 0}@x.y.z)!";
      {
        vendorHash = null;
        subPackages = [ "." ];

        src = stdenv.mkDerivation {
          pname = "caddy-src-with-plugins-${pluginsHash}";
          version = finalAttrs.version;

          nativeBuildInputs = [
            go
            xcaddy
            cacert
            git
          ];
          dontUnpack = true;
          buildPhase =
            let
              withArgs = lib.concatMapStrings (plugin: "--with ${plugin} ") pluginsSorted;
            in
            ''
              export GOCACHE=$TMPDIR/go-cache
              export GOPATH="$TMPDIR/go"
              XCADDY_SKIP_BUILD=1 TMPDIR="$PWD" xcaddy build v${finalAttrs.version} ${withArgs}
              (cd buildenv* && go mod vendor)
            '';
          installPhase = ''
            mv buildenv* $out
          '';

          outputHashMode = "recursive";
          outputHash = hash;
          outputHashAlgo = "sha256";
        };


        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck

          ${lib.toShellVar "notfound" pluginsSorted}
          while read kind module version; do
            [[ "$kind" = "dep" ]] || continue
            module="''${module}@''${version}"
            for i in "''${!notfound[@]}"; do
              if [[ ''${notfound[i]} = ''${module} ]]; then
                unset 'notfound[i]'
              fi
            done
          done < <($out/bin/caddy build-info)
          if (( ''${#notfound[@]} )); then
            >&2 echo "Plugins not found: ''${notfound[@]}"
            exit 1
          fi

          runHook postInstallCheck
        '';
      });
  };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    mainProgram = "caddy";
    maintainers = with maintainers; [ Br1ght0ne emilylange techknowlogick ];
  };
}
