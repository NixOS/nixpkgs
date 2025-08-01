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
  version = "1.4.5";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    tag = "v${version}";
    hash = "sha256-eDtYnsHZpdIGcgRGHTptlfVf//bxup6ZDWvVkBJdBbE=";
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
    fetcherVersion = 1;
    hash = "sha256-o6wxO8EGRmhcYggJnfxDkH+nbt+isc8bfHji8Hu9YKg=";
  };

  vendorHash = "sha256-nIxsG1O5RG+PDSWBcUWpk+4aFq2cYaxpkgOoDqLjY90=";

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
