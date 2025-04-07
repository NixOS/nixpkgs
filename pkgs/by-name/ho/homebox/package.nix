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
  version = "0.18.0";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    tag = "v${version}";
    hash = "sha256-6iNlx0lBVU/awUZHqRYFKe84D86EJNFF7Nm1XChs75w=";
  };
in
buildGo123Module {
  inherit pname version src;

  vendorHash = "sha256-TxuydZjlT8Y4BB77Z8Tyn8j0SPTU2O12TNm9PQGZXTw=";
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
    hash = "sha256-NjuthspxojlrCofAj4Egre8s5PG7vvPJW5mzrvAW4TQ=";
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
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r $GOPATH/bin/api $out/bin/

    runHook postInstall
  '';

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
