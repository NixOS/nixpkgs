{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "godns";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nahX1XEiH7o+r6XxTAhT4kLTx9oGC+YVnw/U0PvzCO8=";
  };

  vendorHash = "sha256-n56e4kU2BorBwdsjI68V+Kpxby6t/foRP8yQ1RPQuog=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/web";
    hash = "sha256-4QH0jI2KAf935EFNVEwuojZPW10rSAnr5Zr+CNm0DGM=";
  };

  npmRoot = "web";
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

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  preBuild = ''
    npm --prefix="$npmRoot" run build
    go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    changelog = "https://github.com/TimothyYe/godns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yinfeng ];
    mainProgram = "godns";
  };
})
