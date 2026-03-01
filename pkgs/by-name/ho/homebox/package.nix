{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  go_1_25,
  git,
  cacert,
  nixosTests,
}:
let
  pname = "homebox";
  version = "0.23.1";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    tag = "v${version}";
    hash = "sha256-bKPlaiAJUwEQbHKBRnUvwuPB4sTlgltUm426LsSQ7yQ=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-bHrpZ/zrXl/zjDgn8aETDZZBUQAfVgi6WLDUxFUSmiQ=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitly remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go_1_25
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
    hash = "sha256-MG2IzSOjdGIjuKOtbDlI6UY+67+6/AAsnBscFvs2V4o=";
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
