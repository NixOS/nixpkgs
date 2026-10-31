{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "gomodel";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ENTERPILOT";
    repo = "GoModel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J7bL7WaiqM+kL1/duoW5ZGsnzLloro8LjdrJgQ8/V1w=";
  };

  vendorHash = "sha256-KtkO4tElOfeGbaF7NCMB3BZd1Dmo1s1XMh1w+gm+/y0=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/web/dashboard";
    hash = "sha256-w/Q0PQeX3HmbRRZi3uT5slPVmY/H5Y1nVOeYtgCpRVE=";
  };

  # paraglide-js plugins are resolved via `./node_modules/...` paths in
  # `project.inlang/settings.json`, so no patchPhase is needed.

  npmRoot = "web/dashboard";
  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = oldAttrs: {
    # Do not add `npmConfigHook` to `goModules`
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    # Do not run `preBuild` when building `goModules`
    preBuild = null;
  };

  # Tests require network services (Redis, Postgres, etc.)
  doCheck = false;

  # nixpkgs has Go 1.27.2; go.mod requires 1.27.3 (a patch release with no
  # new language features). Lower the directive to match the available
  # toolchain. `go mod tidy` later will restore the real value.
  prePatch = ''
    sed -i 's/^go 1\.27\.3$/go 1.27.2/' go.mod
  '';

  preBuild = ''
    npm --prefix="$npmRoot" run build
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/enterpilot/gomodel/internal/version.Version=${finalAttrs.version}"
    "-X github.com/enterpilot/gomodel/internal/version.Commit=v${finalAttrs.version}"
    "-X github.com/enterpilot/gomodel/internal/version.Date=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fastest and most resource-efficient AI gateway with caching, cost tracking, budgets, rate limits, virtual models, failover, MCP gateway, plugins and workflows";
    longDescription = ''
      GoModel is an OpenAI- and Anthropic-compatible AI gateway written in Go.
      It is positioned as a faster, leaner alternative to LiteLLM and Portkey,
      with built-in support for many LLM providers, request caching, cost
      tracking, budgets, rate limits, virtual models, automatic failover,
      provider rotation, an MCP gateway, a plugin system, and a Svelte-based
      web dashboard.
    '';
    homepage = "https://github.com/ENTERPILOT/GoModel";
    changelog = "https://github.com/ENTERPILOT/GoModel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ser ];
    mainProgram = "gomodel";
  };
})
