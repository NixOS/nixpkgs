{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "godns";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LdMeb7pFYj+6HdUBgFkS756oox2HRgkwlHz65SgJoqY=";
  };

  vendorHash = "sha256-wGaRJFxuhwwwP7CBZ7eY5uR95EMdpWiJuU43eWXtHNo=";

  npmDeps = fetchNpmDeps {
    src = stdenv.mkDerivation {
      name = "godns-web-src";
      src = "${finalAttrs.src}/web";
      packageLock = ./package-lock.json;
      dontUnpack = true;
      installPhase = ''
        mkdir $out
        cp -r $src/* $out
        chmod +w $out
        cp ${finalAttrs.packageLock} $out/package-lock.json
      '';
    };
    hash = "sha256-f8BU3HfQX9E+AFpXvNjRJNwT5nX1WwyinMRb7DP0FYU=";
  };

  packageLock = ./package-lock.json;

  npmRoot = "web";
  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postPatch = ''
    cp ${finalAttrs.packageLock} web/package-lock.json
  '';

  overrideModAttrs = oldAttrs: {
    # Do not add `npmConfigHook` to `goModules`
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    # Do not run `preBuild` when building `goModules`
    preBuild = null;
  };

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  __darwinAllowLocalNetworking = true;

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
