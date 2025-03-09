{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  go_1_23,
  git,
  cacert,
  nixosTests,
}:
let
  pname = "homebox";
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    rev = "v${version}";
    hash = "sha256-XzO/aJcLGu+ZHt9fDUhUzBbUS9VpChFVOH0cgvYK6kc=";
  };
in
buildGo123Module {
  inherit pname version src;

  vendorHash = "sha256-Zo/yI1mNeN0O9gZsHux6aOzBlv72h17s7QNO+MaG2/g=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitly remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go_1_23
      git
      cacert
    ];
    preBuild = "";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version;
    src = "${src}/frontend";
    hash = "sha256-nbZxCUXgXoaxIiJsB57OZ7YUkD7Njccj6nFkaHBbctw=";
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
    pnpm_9
    pnpm_9.configHook
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
