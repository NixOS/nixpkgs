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
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gCEAsuv2H7sXWk9zQW70EOqPmEtTU2DYDLXhEK0q1QA=";
  };

  vendorHash = "sha256-P7EXBRG6OYIwaoObqpKBK2n0f6QYphr+DRNLbfysotA=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/front";
    hash = "sha256-5N4dmtKdZgwulqxFHYKhnHOYAg0gnb/rzVVcmzjYFUg=";
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
