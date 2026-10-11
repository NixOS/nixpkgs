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
  version = "0.1.101";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ENTERPILOT";
    repo = "GoModel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z2aWXghSbKCieHn4UrEkIGJCPnjB5LP3nOOuZ4rL0xU=";
  };

  vendorHash = "sha256-qt98m3vLV7CJszsK7VjLxmv6JlrcS5hk0Z7E9DhA7S4=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/web/dashboard";
    hash = "sha256-xYbhtBYAEHJ/iwv7t/uM9gDw0RmTfV5fn9C+okOeRh0=";
  };

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

  # nixpkgs has Go 1.27.1; go.mod requires 1.27.2 (a patch release with no
  # new language features). Lower the directive to match the available
  # toolchain. `go mod tidy` later will restore the real value.
  prePatch = ''
    sed -i 's/^go 1\.27\.2$/go 1.27.1/' go.mod
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
