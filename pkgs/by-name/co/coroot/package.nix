{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  pkg-config,
  nodejs,
  npmHooks,
  lz4,
}:

buildGoModule (finalAttrs: {
  pname = "coroot";
  version = "1.26.8";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6vnJsj3PMRsC/Mal76tWcMVIf7EmvBQj4W0OzZSEUdc=";
  };

  vendorHash = "sha256-QB5jz+ks9naRM7KvlxXUkMcTTtmy0SQXkfxGx/vh3W4=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/front";
    hash = "sha256-QFuEdsyQUmvFGXGBJyOd5UKJv7JEWQ24YM3BwTMUNGU=";
  };

  nativeBuildInputs = [
    pkg-config
    nodejs
    npmHooks.npmConfigHook
  ];
  buildInputs = [ lz4 ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  npmRoot = "front";
  preBuild = ''
    npm --prefix="$npmRoot" run build-prod
  '';

  # required for tests
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Open-source APM & Observability tool";
    homepage = "https://coroot.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot";
  };
})
