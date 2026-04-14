{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  go,
  git,
  cacert,
  nixosTests,
}:
let
  pname = "homebox";
  version = "0.24.0";
  src = fetchFromGitHub {
    owner = "sysadminsmedia";
    repo = "homebox";
    tag = "v${version}";
    hash = "sha256-/h+m2M+sljogw/fYbcgOrakeLErTrA87MCGHgZPIV5Y=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-dFjscefpqBNTQOOZ+itVnUtYX2w/MrU8+FjDpy0AuEM=";
  modRoot = "backend";
  # the goModules derivation inherits our buildInputs and buildPhases
  # Since we do pnpm thing in those it fails if we don't explicitly remove them
  overrideModAttrs = _: {
    nativeBuildInputs = [
      go
      git
      cacert
    ];
    preBuild = "";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version;
    src = "${src}/frontend";
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-u1MvHGUVX3cUs3+ZUVgv8LeL8B/R/USi539NMCOZ06E=";
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
    pnpm_10
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
    license = [
      lib.licenses.agpl3Only
      lib.licenses.mit
    ];
    platforms = lib.platforms.linux;
  };
}
