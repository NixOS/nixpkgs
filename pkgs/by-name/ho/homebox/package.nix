{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pnpm,
  nodejs,
  go,
  git,
  cacert,
}:
let
  pname = "homebox";
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    rev = "v${version}";
    hash = "sha256-mhb4q0ja94TjvOzl28WVb3uzkR9MKlqifFJgUo6hfrA=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-QRmP6ichKjwDWEx13sEs1oetc4nojGyJnKafAATTNTA=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitely remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go
      git
      cacert
    ];
    preBuild = "";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version;
    src = "${src}/frontend";
    hash = "sha256-MdTZJ/Ichpwc54r7jZjiFD12YOdRzHSuzRZ/PnDk2mY=";
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

  meta = {
    mainProgram = "api";
    homepage = "https://hay-kot.github.io/homebox/";
    description = "Inventory and organization system built for the Home User";
    maintainers = with lib.maintainers; [ patrickdag ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
