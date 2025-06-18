{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

buildGoModule rec {
  pname = "godns";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    tag = "v${version}";
    hash = "sha256-Uf+V6A5Q1gQQn+hJUUwmeaGve8364Lui2dMeCzkkeTQ=";
  };

  vendorHash = "sha256-PrXi460v7ooBhFooLw14tMDvLvEzIYt+4Y+36BYdWzA=";
  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = "sha256-+a5IrJLamuNmwGhPIA7JKvgm6COnYre6bPuAv1PgGns=";
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
    "-X main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    changelog = "https://github.com/TimothyYe/godns/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yinfeng ];
    mainProgram = "godns";
  };
}
