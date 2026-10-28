{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  go-swag,
  makeBinaryWrapper,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "garage-ui";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Noooste";
    repo = "garage-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XlzNHTSHr8jJUPHmbyxy71hbjHt46fLPk8n8J0oAfLc=";
  };

  frontend = buildNpmPackage {
    pname = "garage-ui-frontend";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-5WCijC0b8iXKupE/6n9CqWtD+sfK4pgi4MnOOI1XqJA=";

    strictDeps = true;
    __structuredAttrs = true;

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  strictDeps = true;
  __structuredAttrs = true;

  modRoot = "backend";
  vendorHash = "sha256-HSDpfmNbV0a2hNC0TytrzcDjJZpnUFbSZ1mtnt60JRw=";

  excludedPackages = [
    # Fills a development cluster with sample data.
    "cmd/seed"
    # Needs Docker Compose and a running Garage (build tag `smoke`).
    "tests/smoke"
  ];

  nativeBuildInputs = [
    go-swag
    makeBinaryWrapper
  ];

  # The Swagger docs package is generated, not checked in.
  postConfigure = ''
    GOROOT=''${GOROOT-$(go env GOROOT)} swag init
  '';

  # The tests start local HTTP servers.
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # The server looks for the frontend in ./frontend/dist by default. Point it at the store
  # instead of patching that default, which the route tests rely on.
  postInstall = ''
    mkdir -p $out/share
    cp -r ${finalAttrs.frontend} $out/share/garage-ui
    wrapProgram $out/bin/garage-ui \
      --set-default GARAGE_UI_SERVER_FRONTEND_PATH $out/share/garage-ui
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "frontend"
    ];
  };

  meta = {
    description = "Web interface for managing Garage object storage clusters";
    homepage = "https://github.com/Noooste/garage-ui";
    changelog = "https://github.com/Noooste/garage-ui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.unix;
    mainProgram = "garage-ui";
  };
})
