{
  stdenvNoCC,
  lib,
  buildGoModule,
  fetchFromGitHub,
  pnpm,
  nodejs,
}: let
  pname = "homebox";
  version = "0.10.3";
  src = fetchFromGitHub {
    owner = "hay-kot";
    repo = "homebox";
    rev = "v${version}";
    hash = "sha256-Hej/dM0BgtRWiMOpp/SDVr3H1IbYb935T1pfX8apjpE=";
  };
  frontend = stdenvNoCC.mkDerivation {
    pnpmDeps = pnpm.fetchDeps {
      inherit pname version;
      src = "${src}/frontend";
      hash = "sha256-dTqZnmSn3KUzIopSdXRZlWyI6Lu70kLBRWa77/aGkRs=";
    };

    pname = "homebox-frontend";
    inherit version;

    src = "${src}/frontend";

    preBuild = ''
      export HOME=$(mktemp -d)
      cp -Tr "$pnpmDeps" "$STORE_PATH"
      chmod -R +w "$STORE_PATH"

      pnpm config set store-dir "$STORE_PATH"


      echo y |pnpm install --offline --frozen-lockfile --shamefully-hoist
      patchShebangs node_modules/{*,.*}
    '';

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';
    env.NUXT_TELEMETRY_DISABLED = 1;

    nativeBuildInputs = [
      pnpm
      pnpm.configHook
      nodejs
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r .output/public/* $out/

      runHook postInstall
    '';
  };
in
  buildGoModule {
    inherit pname version;
    src = "${src}/backend";

    vendorHash = "sha256-TtFz+dDpoMs3PAQjiYQm1+Q6prn4Hiaf7xqWt41oY7w=";

    CGO_ENABLED = 0;
    GOOS = "linux";
    doCheck = false;

    # options used by upstream:
    # https://github.com/simulot/immich-go/blob/0.13.2/.goreleaser.yaml
    ldflags = [
      "-s"
      "-w"
      "-extldflags=-static"
      "-X main.version=${version}"
      "-X main.commit=${version}"
    ];

    preBuild = ''
      mkdir -p ./app/api/static/public
      cp -r ${frontend}/* ./app/api/static/public
    '';

    meta = {
      mainProgram = "api";
      homepage = "https://hay-kot.github.io/homebox/";
      description = "Inventory and organization system built for the Home User";
      maintainers = with lib.maintainers; [patrickdag];
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.linux;
    };
  }
