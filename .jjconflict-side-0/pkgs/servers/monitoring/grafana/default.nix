{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  removeReferencesTo,
  tzdata,
  wire,
  yarn-berry_4,
  nodejs,
  python3,
  cacert,
  jq,
  moreutils,
  nix-update-script,
  nixosTests,
  xcbuild,
  faketty,
  git,
}:

let
  # Grafana seems to just set it to the latest version available
  # nowadays.
  # NOTE: sometimes, this is a no-op (i.e. `--replace-fail "X" "X"`).
  # This is because Grafana raises the Go version above the patch-level we have
  # on master if a security fix landed in Go (and our go may go through staging first).
  #
  # I(Ma27) decided to leave the code a no-op if this is not the case because
  # pulling it out of the Git history every few months and checking which files
  # we need to update now is slightly annoying.
  patchGoVersion = ''
    find . -name go.mod -not -path "./.bingo/*" -print0 | while IFS= read -r -d ''' line; do
      substituteInPlace "$line" \
        --replace-fail "go 1.23.7" "go 1.23.7"
    done
    find . -name go.work -print0 | while IFS= read -r -d ''' line; do
      substituteInPlace "$line" \
        --replace-fail "go 1.23.7" "go 1.23.7"
    done
    substituteInPlace Makefile \
      --replace-fail "GO_VERSION = 1.23.7" "GO_VERSION = 1.23.7"
  '';
in
buildGoModule rec {
  pname = "grafana";
  version = "11.6.0+security-01";

  subPackages = [
    "pkg/cmd/grafana"
    "pkg/cmd/grafana-server"
    "pkg/cmd/grafana-cli"
  ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana";
    rev = "v${version}";
    hash = "sha256-JG4Dr0CGDYHH6hBAAtdHPO8Vy9U/bg4GPzX6biZk028=";
  };

  # borrowed from: https://github.com/NixOS/nixpkgs/blob/d70d9425f49f9aba3c49e2c389fe6d42bac8c5b0/pkgs/development/tools/analysis/snyk/default.nix#L20-L22
  env = {
    CYPRESS_INSTALL_BINARY = 0;

    # The build OOMs on memory constrained aarch64 without this
    NODE_OPTIONS = "--max_old_space_size=4096";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-tpQjEa4xeD4fmrucynt8WVVXZ3uN5WxjSF8YcjE6HLU=";
  };

  disallowedRequisites = [ offlineCache ];

  postPatch = patchGoVersion;

  vendorHash = "sha256-Ziohfy9fMVmYnk9c0iRNi4wJZd2E8vCP+ozsTM0eLTA=";

  proxyVendor = true;

  nativeBuildInputs = [
    wire
    jq
    moreutils
    removeReferencesTo
    # required to run old node-gyp
    (python3.withPackages (ps: [ ps.distutils ]))
    faketty
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcbuild ];

  postConfigure = ''
    # Generate DI code that's required to compile the package.
    # From https://github.com/grafana/grafana/blob/v8.2.3/Makefile#L33-L35
    wire gen -tags oss ./pkg/server
    wire gen -tags oss ./pkg/cmd/grafana-cli/runner

    GOARCH= CGO_ENABLED=0 go generate ./kinds/gen.go
    GOARCH= CGO_ENABLED=0 go generate ./public/app/plugins/gen.go

  '';

  postBuild = ''
    # After having built all the Go code, run the JS builders now.

    # Workaround for https://github.com/nrwl/nx/issues/22445
    faketty yarn run build
    yarn run plugins:build-bundled
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  # On Darwin, files under /usr/share/zoneinfo exist, but fail to open in sandbox:
  # TestValueAsTimezone: date_formats_test.go:33: Invalid has err for input "Europe/Amsterdam": operation not permitted
  preCheck = ''
    export ZONEINFO=${tzdata}/share/zoneinfo
  '';

  postInstall = ''
    mkdir -p $out/share/grafana
    cp -r public conf $out/share/grafana/
  '';

  postFixup = ''
    while read line; do
      remove-references-to -t $offlineCache "$line"
    done < <(find $out -type f -name '*.js.map' -or -name '*.js')
  '';

  passthru = {
    tests = { inherit (nixosTests) grafana; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.agpl3Only;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [
      offline
      fpletz
      willibutz
      globin
      ma27
      Frostman
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "grafana-server";
  };
}
