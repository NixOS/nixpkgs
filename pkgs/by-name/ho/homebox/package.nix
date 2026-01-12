{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  go_1_24,
  git,
  cacert,
  nixosTests,
}:
let
  pname = "homebox";
  version = "0.22.3";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    tag = "v${version}";
    hash = "sha256-0/pf7jShuoME6it8GPXJ7ugoRLVfpEzu2uaUW0XFwJg=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-pAMWPMZV5U7hIKNNFgRyyqZEH3wjUCplo7cQfKh1A6g=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitly remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go_1_24
      git
      cacert
    ];
    preBuild = "";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version;
    src = "${src}/frontend";
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-5AEwgI5rQzp/36USr+QEzjgllZkKhhIvlzl+9ZVfGM4=";
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
    pnpmConfigHook
    pnpm_9
    nodejs
  ];

  env.CGO_ENABLED = 0;
  doCheck = false;

  tags = [
    "nodynamic"
  ];

  ldflags = [
    "-s"
    "-w"
    "-extldflags=-static"
    "-X main.version=${src.tag}"
    "-X main.commit=${src.tag}"
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
    maintainers = with lib.maintainers; [
      patrickdag
      tebriel
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
