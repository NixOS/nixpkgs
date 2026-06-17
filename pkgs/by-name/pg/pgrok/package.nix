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
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    tag = "v${version}";
    hash = "sha256-uMHeVxAGmAEIOfCK9SEFsL7GZZIUNMYdoV8XeHjXmWc=";
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

  postPatch = ''
    # Rename directories to avoid binary naming conflicts (both would be named "cli")
    mv pgrok/cli pgrok/pgrok
    mv pgrokd/cli pgrokd/pgrokd

    # Update references in Go code and web app package.json to match renamed directory
    substituteInPlace pgrokd/pgrokd/main.go \
      --replace-fail "github.com/pgrok/pgrok/pgrokd/cli/internal/web" "github.com/pgrok/pgrok/pgrokd/pgrokd/internal/web"
    substituteInPlace pgrokd/web/package.json \
      --replace-fail "../cli/internal/web/dist" "../pgrokd/internal/web/dist"
  '';

  env.pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-O3bDxnxeRO20FsRNpgXfz4UweYJmeU6zgrrPJ05fgWo=";
  };

  vendorHash = "sha256-fhyyyXHUJsIWiCZbqtLZZRuIG9hb0LAkSo7lKW0i8Sk";

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
