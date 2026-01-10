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
  version = "1.17.7";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-rfAJIRisLKkS6SuVJFLWjVnTAqbP+axuk3ECJ5n/7ek=";
  };

  vendorHash = "sha256-DCdrE8UYkuUN+rUuxVSGbAnAeLivZ2Xp8xjM+56ZF+A=";
  npmDeps = fetchNpmDeps {
    src = "${src}/front";
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
}
