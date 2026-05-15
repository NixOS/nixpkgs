{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  stdenv,
  go_1_26,
  nix-update-script,
}:

let
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "maximhq";
    repo = "bifrost";
    tag = "transports/v${version}";
    hash = "sha256-5hZoTEoKrt1cjkHxTjKUs44wXn1fpqL9LoxbfF5Q4NE=";
  };

  ui = buildNpmPackage {
    pname = "bifrost-ui";
    inherit version src;
    sourceRoot = "${src.name}/ui";

    npmDepsHash = "sha256-6DmtaiLUjYbhldYGEig0sx3e6PUuQVjA2FLU95fqQ+Y=";

    # `next/font/google` fetches fonts at build time; the Nix sandbox has no
    # network access, so replace the layout with an offline-friendly version.
    postPatch = ''
      cat > app/layout.tsx <<'EOF'
      import "./globals.css"

      export default function RootLayout({ children }: { children: React.ReactNode }) {
        return (
          <html lang="en" suppressHydrationWarning>
            <body className="font-sans antialiased">{children}</body>
          </html>
        )
      }
      EOF
    '';

    npmBuildScript = "build-enterprise";

    env = {
      NEXT_TELEMETRY_DISABLED = "1";
      NEXT_DISABLE_ESLINT = "1";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/ui"
      cp -R --no-preserve=mode,ownership,timestamps out/. "$out/ui/"
      runHook postInstall
    '';
  };
in
(buildGoModule.override { go = go_1_26; }) (finalAttrs: {
  pname = "bifrost";
  inherit version src;

  __structuredAttrs = true;

  modRoot = "transports";
  subPackages = [ "bifrost-http" ];
  vendorHash = "sha256-l/+CPu7kKOjki5hLKK/ltHxZM7SNcI3/e/FLoV0ScS0=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  env.CGO_ENABLED = "1";

  # The `transports` module references sibling modules via `replace` directives
  # that point at relative paths inside the workspace. Re-declare them here so
  # buildGoModule resolves them from the unpacked source tree.
  postPatch = ''
    # Upstream requires Go 1.26.2 but nixpkgs currently ships 1.26.1. The
    # source is compatible — relax the toolchain pin in every go.mod so the
    # build works until nixpkgs bumps go_1_26.
    find . -name go.mod -exec sed -i 's/^go 1\.26\.[0-9]*$/go 1.26.1/' {} +

    cat >> transports/go.mod <<'EOF'

    replace github.com/maximhq/bifrost/core => ../core
    replace github.com/maximhq/bifrost/framework => ../framework
    replace github.com/maximhq/bifrost/plugins/compat => ../plugins/compat
    replace github.com/maximhq/bifrost/plugins/governance => ../plugins/governance
    replace github.com/maximhq/bifrost/plugins/logging => ../plugins/logging
    replace github.com/maximhq/bifrost/plugins/maxim => ../plugins/maxim
    replace github.com/maximhq/bifrost/plugins/mocker => ../plugins/mocker
    replace github.com/maximhq/bifrost/plugins/otel => ../plugins/otel
    replace github.com/maximhq/bifrost/plugins/prompts => ../plugins/prompts
    replace github.com/maximhq/bifrost/plugins/semanticcache => ../plugins/semanticcache
    replace github.com/maximhq/bifrost/plugins/telemetry => ../plugins/telemetry
    EOF
  '';

  overrideModAttrs = _: prev: {
    postPatch = (prev.postPatch or "") + finalAttrs.postPatch;
  };

  # Provide the pre-built UI for //go:embed all:ui inside bifrost-http.
  preBuild = ''
    rm -rf bifrost-http/ui
    mkdir -p bifrost-http/ui
    cp -R --no-preserve=mode,ownership,timestamps ${ui}/ui/. bifrost-http/ui/
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
    changelog = "https://github.com/maximhq/bifrost/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "bifrost-http";
    platforms = lib.platforms.linux;
  };
})
