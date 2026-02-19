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
  version = "1.17.9";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hr1t3WaYEOYnj3Cam2NGgiGD49Vr9HBkz4JmOlJxzQQ=";
  };

  vendorHash = "sha256-DCdrE8UYkuUN+rUuxVSGbAnAeLivZ2Xp8xjM+56ZF+A=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/front";
    hash = "sha256-6a8eOPgAdpZpdXmrHVw/twfikjjWHSy/BdYdlyRQkjc=";
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
})
