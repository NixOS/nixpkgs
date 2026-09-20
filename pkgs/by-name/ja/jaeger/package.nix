{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  gzip,
  nix-update-script,
  nodejs_24,
  withUI ? true,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "jaeger";
  version = "2.17.0";

  # jaeger-ui lives under jaeger-ui/ as a git submodule.
  src = fetchFromGitHub {
    owner = "jaegertracing";
    repo = "jaeger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0bP9MiJZ+mQs5LYKeIT/Mc+UEEMXy3yWMU2GXIgDOLU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-G7+QgAQslUJGy5qCSGlp50AaP3BF8z6iEx/FgG9eWBE=";

  # Lifted to the top level so nix-update can update the hash via passthru.
  # v2 fetcher required for lockfileVersion 3 + npm 11.
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/jaeger-ui";
    hash = "sha256-qDfQxm1ScVp94eOfS+/rCVX7C6MgnGtPtMczlhN44o8=";
    fetcherVersion = 2;
  };

  # React web UI, built standalone and later embedded into the Go binary.
  frontend = buildNpmPackage {
    pname = "jaeger-ui";
    inherit (finalAttrs) version npmDeps;

    src = "${finalAttrs.src}/jaeger-ui";
    nodejs = nodejs_24;
    npmDepsFetcherVersion = 2;

    # vite resolves `localhost` during build; the Darwin sandbox blocks DNS
    # unless loopback networking is explicitly allowed.
    __darwinAllowLocalNetworking = true;

    # Normally set at build time by scripts/get-tracking-version.js (which
    # shells out to git); feed a static stub instead.
    env.REACT_APP_VSN_STATE = builtins.toJSON { inherit (finalAttrs) version; };

    # Drop the inline `REACT_APP_VSN_STATE=$(...)` so the env above wins.
    postPatch = ''
      substituteInPlace packages/jaeger-ui/package.json \
        --replace-fail 'REACT_APP_VSN_STATE=$(../../scripts/get-tracking-version.js) ' ""
    '';

    # npmConfigHook only patches shebangs under the root node_modules; workspace-
    # local node_modules (packages/*/node_modules) are missed, leaving scripts
    # like vite with `#!/usr/bin/env node` that the Darwin sandbox rejects.
    preBuild = ''
      patchShebangs packages/*/node_modules
    '';

    # Keep only the built UI assets; drop the workspace node_modules, sources, etc.
    installPhase = ''
      runHook preInstall
      cp -r packages/jaeger-ui/build $out
      runHook postInstall
    '';
  };

  subPackages = [ "cmd/jaeger" ];

  nativeBuildInputs = lib.optional withUI gzip;

  ldflags = [
    "-s"
    "-w"
  ];

  # go:embed expects gzipped assets under internal/ui/actual/; drop the built
  # UI in, then gzip everything except .gitignore.
  preBuild = lib.optionalString withUI ''
    cp -r ${finalAttrs.frontend}/. cmd/jaeger/internal/extension/jaegerquery/internal/ui/actual/
    chmod -R u+w cmd/jaeger/internal/extension/jaegerquery/internal/ui/actual
    find cmd/jaeger/internal/extension/jaegerquery/internal/ui/actual -type f \
      ! -name '.gitignore' -exec gzip --no-name {} +
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = lib.optionals withUI [
        "--subpackage"
        "frontend"
      ];
    };
  }
  // lib.optionalAttrs withUI {
    # Exposed for nix-update to discover and bump on version changes.
    inherit (finalAttrs) frontend npmDeps;
  };

  meta = {
    description = "Distributed tracing platform";
    homepage = "https://www.jaegertracing.io";
    license = lib.licenses.asl20;
    mainProgram = "jaeger";
    maintainers = with lib.maintainers; [ jonhermansen ];
    platforms = lib.platforms.unix;
  };
})
