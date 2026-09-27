{
  lib,
  buildGo127Module,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  nix-update-script,
}:

let
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "maximhq";
    repo = "bifrost";
    tag = "transports/v${version}";
    hash = "sha256-scOAEWRrKEx6sz74scjJAbiW6EYaW6EaZPdyQUkVqqE=";
  };

  ui = buildNpmPackage {
    pname = "bifrost-ui";
    inherit version src;
    sourceRoot = "${src.name}/ui";

    npmDepsHash = "sha256-1eEw976l9xb0nLyoc5vUv1536EUvmdVtCBdz+FpprgQ=";

    # The default `build` script also copies its output into the Go tree, which
    # lies outside this source root; `build-enterprise` only runs the build.
    npmBuildScript = "build-enterprise";

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/ui"
      cp -R --no-preserve=all out/. "$out/ui/"
      runHook postInstall
    '';
  };
in
buildGo127Module (finalAttrs: {
  pname = "bifrost";
  inherit version src;

  __structuredAttrs = true;

  modRoot = "transports";
  subPackages = [ "bifrost-http" ];
  vendorHash = "sha256-lIGk1klUBlAS4hAc8wlGOquea0QDEb33IRPvxv+FO9E=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  env.CGO_ENABLED = "1";

  # The `transports` module references sibling modules via `replace` directives
  # that point at relative paths inside the workspace. Re-declare them here so
  # buildGoModule resolves them from the unpacked source tree.
  postPatch = ''
    cat >> transports/go.mod <<'EOF'

    replace github.com/maximhq/bifrost/core => ../core
    replace github.com/maximhq/bifrost/framework => ../framework
    replace github.com/maximhq/bifrost/plugins/compat => ../plugins/compat
    replace github.com/maximhq/bifrost/plugins/governance => ../plugins/governance
    replace github.com/maximhq/bifrost/plugins/logging => ../plugins/logging
    replace github.com/maximhq/bifrost/plugins/maxim => ../plugins/maxim
    replace github.com/maximhq/bifrost/plugins/mocker => ../plugins/mocker
    replace github.com/maximhq/bifrost/plugins/modelcatalogresolver => ../plugins/modelcatalogresolver
    replace github.com/maximhq/bifrost/plugins/otel => ../plugins/otel
    replace github.com/maximhq/bifrost/plugins/prompts => ../plugins/prompts
    replace github.com/maximhq/bifrost/plugins/routing => ../plugins/routing
    replace github.com/maximhq/bifrost/plugins/semanticcache => ../plugins/semanticcache
    replace github.com/maximhq/bifrost/plugins/telemetry => ../plugins/telemetry
    EOF
  '';

  # `goModules` inherits `postPatch` on its own, but also `preBuild`, which the
  # module fetcher has no use for: it would pull the whole UI into the fetcher
  # and rebuild it on every UI change.
  overrideModAttrs = _: _: {
    preBuild = "";
  };

  # Provide the pre-built UI for //go:embed all:ui inside bifrost-http.
  preBuild = ''
    rm -rf bifrost-http/ui
    mkdir -p bifrost-http/ui
    cp -R --no-preserve=all ${ui}/ui/. bifrost-http/ui/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  passthru = {
    inherit ui;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "High-performance LLM gateway with native MCP support";
    longDescription = ''
      Bifrost is an OpenAI-compatible HTTP gateway that unifies access to 15+
      LLM providers, exposes Model Context Protocol (MCP) servers behind a
      single endpoint, and adds semantic caching, automatic failover and
      weighted key selection.
    '';
    homepage = "https://github.com/maximhq/bifrost";
    changelog = "https://github.com/maximhq/bifrost/releases/tag/transports/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "bifrost-http";
    platforms = lib.platforms.linux;
  };
})
