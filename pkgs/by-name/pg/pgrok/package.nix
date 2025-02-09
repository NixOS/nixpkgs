{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
}:

let
  pname = "pgrok";
  version = "1.4.4";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    tag = "v${version}";
    hash = "sha256-1T3PUMgtEfjbCFmUKwKVofHPCCE0Hw1F18iC0mfh4KQ=";
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
    pnpm_9.configHook
  ];

  env.pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-xObDEkNGMXcUqX9thAJoE45yzd7f15k2odDWv9X3RRE=";
  };

  vendorHash = "sha256-1s8PPP/Q5bSJleCPZ6P4BwLEan/lelohRKX/0RStdvY=";

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
