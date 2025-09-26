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
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    tag = "v${version}";
    hash = "sha256-go6LUVr53ioCpzWwShe7Ol2p57HH/cAcsD+g7I0ix2E=";
  };

  vendorHash = "sha256-FHao4E0hhmnM224f8CowcHFAN2fmcR7TN08ldKZ5DUw=";
  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = "sha256-D0R9CUMlm+oesfD+Gr+Cqi37XETMhQ9n9MSKJOYqe9g=";
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
