{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  pnpm,
  nodejs,
  go_1_23,
  git,
  cacert,
  nixosTests,
}:
let
  pname = "homebox";
  version = "0.15.2";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    rev = "v${version}";
    hash = "sha256-2jB2Oo0dK36n5tQPrGNyPO3Q0yNkUms4RPQzXiDzuks=";
  };
in
buildGo123Module {
  inherit pname version src;

  vendorHash = "sha256-Ftm5tR3w8S3mjYLJG0+17nYP5kDbaAd8QkbZpNt7WuE=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitely remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go_1_23
      git
      cacert
    ];
    preBuild = "";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version;
    src = "${src}/frontend";
    hash = "sha256-fOb3oboNlOv/TpIrs3BsSlxIqNbbtSCE8zLMia2RIDw=";
  };
  pnpmRoot = "../frontend";

  env.NUXT_TELEMETRY_DISABLED = 1;

  preBuild = ''
    pushd ../frontend

    pnpm build

    popd

    mkdir -p ./app/api/static/public
    cp -r ../frontend/.output/public/* ./app/api/static/public
  '';

  nativeBuildInputs = [
    pnpm
    pnpm.configHook
    nodejs
  ];

  CGO_ENABLED = 0;
  GOOS = "linux";
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-extldflags=-static"
    "-X main.version=${version}"
    "-X main.commit=${version}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) homebox;
    };
  };

  meta = {
    mainProgram = "api";
    homepage = "https://homebox.software/";
    description = "Inventory and organization system built for the Home User";
    maintainers = with lib.maintainers; [ patrickdag ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
