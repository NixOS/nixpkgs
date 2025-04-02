{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "docker-slim";
  version = "1.41.7";

  src = fetchFromGitHub {
    owner = "mintoolkit";
    repo = "mint";
    tag = version;
    hash = "sha256-gPssqt3/irMeKQXxwSA2UZ0j1zLumdc1NLO9kogvjOI=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/mint"
    "cmd/mint-sensor"
  ];

  tags = [ "containers_image_openpgp" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  preBuild = ''
    go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mintoolkit/mint/pkg/version.appVersionTag=${version}"
    "-X github.com/mintoolkit/mint/pkg/version.appVersionRev=${src.rev}"
  ];

  # docker-slim tries to create its state dir next to the binary (inside the nix
  # store), so we set it to use the working directory at the time of invocation
  postInstall = ''
    wrapProgram "$out/bin/mint" --add-flags '--state-path "$(pwd)"'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/mint";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://github.com/mintoolkit/mint"; # no domain registered yet
    changelog = "https://github.com/mintoolkit/mint/raw/${version}/CHANGELOG.md";
    license = licenses.asl20;
    mainProgram = "mint";
    maintainers = with maintainers; [
      Br1ght0ne
      mbrgm
    ];
  };
}
