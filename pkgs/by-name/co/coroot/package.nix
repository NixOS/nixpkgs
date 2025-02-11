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

buildGoModule rec {
  pname = "coroot";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-ndzn0ZcuzdmCXnijUr6jq3KSFqSdF2FYd/2qi5Huk5Y=";
  };

  vendorHash = "sha256-wyxNT8g5TUCjlxauL7NmCf4HZ91V2nD64L1L/rYH864=";
  npmDeps = fetchNpmDeps {
    src = "${src}/front";
    hash = "sha256-inZV+iv837+7ntBae/oLSNLxpzoqEcJNPNdBE+osJHQ=";
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

  meta = {
    description = "Open-source APM & Observability tool";
    homepage = "https://coroot.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot";
  };
}
