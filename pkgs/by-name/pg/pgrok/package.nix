{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm,
}:

let
  pname = "pgrok";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    rev = "v${version}";
    hash = "sha256-P36rpFi5J+dF6FrVaPhqupG00h4kwr0qumt4ehL/7vU=";
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
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-1PUcISW1pC9+5HZyI9SIDRyhos5f/6aW1wa2z0OKams=";
  };

  vendorHash = "sha256-X5FjzliIJdfJnNaUXBjv1uq5tyjMVjBbnLCBH/P0LFM=";

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
