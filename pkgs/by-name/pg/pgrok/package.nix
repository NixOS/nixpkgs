{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

let
  pname = "pgrok";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    tag = "v${version}";
    hash = "sha256-arPFccclBie3XOBt0q6UC96fPaPc7NmgQDMsd2H2bhI=";
  };
in

buildGoModule {
  inherit pname version src;

  outputs = [
    "out"
    "server"
  ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  env.pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-D8UZoN0ZnjB8CXQiHmBZwBEt57XGb5SDLg61xxSqNus=";
  };

  vendorHash = "sha256-ob8s1jYL2+JGaqjCsM10jgirPiEyTY4U3IVVlHVdoGQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=unknown"
    "-X main.date=unknown"
  ];

  subPackages = [
    "pgrok/pgrok"
    "pgrokd/pgrokd"
  ];

  preBuild = ''
    pushd pgrokd/web

    pnpm run build

    popd

    # rename packages due to naming conflict
    mv pgrok/cli/ pgrok/pgrok/
    mv pgrokd/cli/ pgrokd/pgrokd/
  '';

  postInstall = ''
    moveToOutput bin/pgrokd $server
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Selfhosted TCP/HTTP tunnel, ngrok alternative, written in Go";
    homepage = "https://github.com/pgrok/pgrok";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "pgrok";
  };
}
