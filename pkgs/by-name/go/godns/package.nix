{ lib
, buildGoModule
, fetchFromGitHub
, nodejs
, npmHooks
, fetchNpmDeps
, nix-update-script
}:

buildGoModule rec {
  pname = "godns";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kr+zMmjpHR2JtCaDyLMcQwOUXlPJeisu94zHRpEYV/I=";
  };

  vendorHash = "sha256-E15h5p4ppRb91EUoz5dyWNFl745rt419NMCSurMLxis=";
  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = "sha256-2yeqLly0guU/kpX+yH/QOoDGzyJTxkTaCt8EleJhybU=";
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

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    changelog = "https://github.com/TimothyYe/godns/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
    mainProgram = "godns";
  };
}
