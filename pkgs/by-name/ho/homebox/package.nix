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
  version = "0.16.0";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    rev = "v${version}";
    hash = "sha256-d8SQWj7S6G1ZemMH6QL9QZuPQfxNRcfCurPaTnS0Iyo=";
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
    hash = "sha256-x7sWSH84UJEXNRLCgEgXc4NrTRsn6OplANi+XGtIN9Y=";
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

  env.CGO_ENABLED = 0;
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
