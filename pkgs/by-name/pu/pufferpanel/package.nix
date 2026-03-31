{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  makeWrapper,
  go-swag,
  nixosTests,
  testers,
  pufferpanel,
  yarn,
}:

buildGoModule rec {
  pname = "pufferpanel";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "PufferPanel";
    repo = "PufferPanel";
    rev = "v${version}";
    hash = "sha256-h8DWaj/gVCS9UELmb9RdjHlL9vlsVYouDYWNPy6pIqQ=";
  };

  patches = [
    ./disable-group-checks.patch

    # Some tests do not have network requests stubbed :(
    ./skip-network-tests.patch
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pufferpanel/pufferpanel/v3.Hash=none"
    "-X=github.com/pufferpanel/pufferpanel/v3.Version=${version}-nixpkgs"
  ];

  frontend = buildNpmPackage {
    pname = "pufferpanel-frontend";
    inherit version;

    src = "${src}/client";

    npmDepsHash = "sha256-Mx/DmHDJ8J8y9ec9JJ8nI8bnk8ueNBcIREMhXFiEbVI=";

    nativeBuildInputs = [ yarn ];

    NODE_OPTIONS = "--openssl-legacy-provider";
    installPhase = ''
      cp -r frontend/dist $out
    '';
    dontNpmInstall = true;
  };

  nativeBuildInputs = [
    makeWrapper
    go-swag
  ];

  vendorHash = "sha256-GOHv3xaJKmO08pyeIb0jGn0eCx3quQITE8G18otKq/4=";
  proxyVendor = true;

  # Generate code for Swagger documentation endpoints (see web/swagger/docs.go).
  # Note that GOROOT embedded in go-swag is empty by default since it is built
  # with -trimpath (see https://go.dev/cl/399214). It looks like go-swag skips
  # file paths that start with $GOROOT, thus all files when it is empty.
  preBuild = ''
    GOROOT=''${GOROOT-$(go env GOROOT)} swag init --parseDependency --markdownFiles . --output web/swagger --generalInfo web/loader.go
    cp -r ${frontend} client/frontend/dist
  '';

  installPhase = ''
    runHook preInstall

    # Set up directory structure similar to the official PufferPanel releases.
    mkdir -p $out/share/pufferpanel
    cp "$GOPATH"/bin/cmd $out/share/pufferpanel/pufferpanel
    cp web/swagger/swagger.{json,yaml} $out/share/pufferpanel

    # Wrap the binary with the path to the external files, but allow setting
    # custom paths if needed.
    makeWrapper $out/share/pufferpanel/pufferpanel $out/bin/pufferpanel \
      --set-default GIN_MODE release

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) pufferpanel;
    version = testers.testVersion {
      package = pufferpanel;
      command = "${pname} version";
    };
  };

  meta = {
    description = "Free, open source game management panel";
    homepage = "https://www.pufferpanel.com/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ tie ];
    mainProgram = "pufferpanel";
  };
}
