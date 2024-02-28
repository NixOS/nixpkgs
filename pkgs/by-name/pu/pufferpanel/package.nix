{ lib
, fetchFromGitHub
, buildGoModule
, fetchNpmDeps
, npmHooks
, nodejs
, go-swag
, makeWrapper
, nixosTests
, testers
, pufferpanel
}:
buildGoModule rec {
  pname = "pufferpanel";
  version = "2.6.10";

  src = fetchFromGitHub {
    owner = "PufferPanel";
    repo = "PufferPanel";
    rev = "v${version}";
    hash = "sha256-NGZ5jSlx8f6qgBamHxECq7x/7uKsWjAINzAPHTuoKp8=";
  };

  patches = [
    # Bump sha1cd package, otherwise i686-linux fails to build.
    ./bump-sha1cd.patch

    # Seems to be an anti-feature. Startup is the only place where user/group is
    # hardcoded and checked.
    #
    # There is no technical reason PufferPanel cannot run as a different user,
    # especially for simple commands like `pufferpanel version`.
    ./disable-group-checks.patch

    # Some tests do not have network requests stubbed :(
    ./skip-network-tests.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    npmHooks.npmConfigHook
    nodejs
    go-swag
  ];

  npmRoot = "client";
  npmDeps = fetchNpmDeps {
    src = "${src}/${npmRoot}";
    hash = "sha256-oWFXtV/dxzHv3sfIi01l1lHE5tcJgpVq87XgS6Iy62g=";
  };

  # buildGoModule “helpfully” passes nativeBuildInputs (along with npm hook) to
  # the goModules derivation. This breaks the build since the hook cannot find
  # required dependencies.
  overrideModAttrs = (_: {
    inherit npmRoot npmDeps;
  });

  vendorHash = "sha256-402ND99FpU+zNV1e5Th1+aZKok49cIEdpPPLLfNyL3E=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pufferpanel/pufferpanel/v2.Hash=none"
    "-X=github.com/pufferpanel/pufferpanel/v2.Version=${version}-nixpkgs"
  ];

  buildPhase = ''
    runHook preBuild

    NODE_OPTIONS=--openssl-legacy-provider \
      npm -C "$npmRoot" run build

    # Generate code for Swagger documentation endpoints (see web/swagger/docs.go).
    # Note that GOROOT embedded in go-swag is empty by default since it is built
    # with -trimpath (see https://go.dev/cl/399214). It looks like go-swag skips
    # file paths that start with $GOROOT, thus all files when it is empty.
    GOROOT=$(go env GOROOT) \
      swag init \
      --output web/swagger \
      --generalInfo web/loader.go

    go build -x \
      -ldflags="''${ldflags[*]}" \
      -o=pufferpanel \
      github.com/pufferpanel/pufferpanel/v2/cmd

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    go test -v github.com/pufferpanel/pufferpanel/v2/...
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    # Set up directory structure similar to the official PufferPanel releases.
    mkdir -p $out/share/pufferpanel
    mv pufferpanel $out/share/pufferpanel/pufferpanel
    mv client/dist $out/share/pufferpanel/www
    cp -r $src/assets/email $out/share/pufferpanel/email
    cp web/swagger/swagger.{json,yaml} $out/share/pufferpanel

    # Wrap the binary with the path to the external files, but allow setting
    # custom paths if needed.
    makeWrapper $out/share/pufferpanel/pufferpanel $out/bin/pufferpanel \
      --set-default GIN_MODE release \
      --set-default PUFFER_PANEL_EMAIL_TEMPLATES $out/share/pufferpanel/email/emails.json \
      --set-default PUFFER_PANEL_WEB_FILES $out/share/pufferpanel/www

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) pufferpanel;
    version = testers.testVersion {
      package = pufferpanel;
      command = "${pname} version";
    };
  };

  meta = with lib; {
    description = "A free, open source game management panel";
    homepage = "https://pufferpanel.com";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ckie tie ];
    mainProgram = "pufferpanel";
  };
}
