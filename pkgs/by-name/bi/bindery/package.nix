{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

let
  version = "1.46.1";

  src = fetchFromGitHub {
    owner = "vavallee";
    repo = "bindery";
    tag = "v${version}";
    hash = "sha256-S2NhicVfTYwsobn4IufCuui3Pua4mRck+e+UMLRJ370=";
  };

  # Tests skipped by `checkFlags` below. The indexer tests register an indexer
  # URL, which upstream validates with a real DNS lookup (its SSRF guard); the
  # sandbox has no resolver, so they cannot pass offline.
  skippedTests = [
    "TestIndexerCRUD"
    "TestIndexerUpdate_RequestBodyHandling"
    "TestIndexerCreate_DuplicateURL"
    "TestIndexerUpdate_WriteOnlyAPIKey"
    "TestIndexerDailyQueryLimit_API"
    "TestIndexerDailyQueryUsage_SurvivesASave"
  ];

  skipTestsRegex = "^(" + lib.concatStringsSep "|" skippedTests + ")$";

  # React SPA embedded into the binary through internal/webui/embed.go.
  # Upstream keeps the frontend in web/ and copies web/dist into
  # internal/webui/dist before `go build` (see the Makefile).
  webui = buildNpmPackage {
    pname = "bindery-webui";
    inherit src version;

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-Ceot8FSiO5TJacwW7RnapTPbdzbPk38UQz+odQPLQIs=";
    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      cp -r dist "$out"

      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "bindery";
  inherit version src;

  __structuredAttrs = true;

  # Many tests start an httptest.Server, and the Darwin sandbox refuses to bind
  # even an IPv6 loopback listener (`listen tcp6 [::1]:0: bind: operation not
  # permitted`). Local networking is not needed to build, only to check.
  __darwinAllowLocalNetworking = true;

  vendorHash = "sha256-tv5WrP1NRSO3r6iUTlYBHqnXC7V1fyMxTAdNPxHPiwc=";

  nativeBuildInputs = [ makeWrapper ];

  # Upstream also ships cmd/telemetry-server and cmd/discord-stats; only
  # cmd/bindery is the application.
  subPackages = [ "cmd/bindery" ];

  # Upstream release builds set CGO_ENABLED=0 (.goreleaser.yaml) and the SQLite
  # driver is the pure-Go modernc.org/sqlite, so no C toolchain is needed.
  env.CGO_ENABLED = "0";

  # The tarball carries only internal/webui/dist/.gitkeep (dist contents are
  # gitignored upstream), so drop it before unpacking the built SPA.
  preBuild = ''
    rm -rf internal/webui/dist
    mkdir -p internal/webui/dist
    cp -r ${webui}/. internal/webui/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Upstream pings api.getbindery.dev at startup and daily (see PRIVACY.md), and
  # enables it for any version that looks like a release tag -- which ours does,
  # since main.version is injected above. Opt out by default while leaving the
  # user able to re-enable it, as done for gh, glab, cloud-nuke and riff.
  postInstall = ''
    wrapProgram $out/bin/bindery \
      --set-default BINDERY_TELEMETRY_DISABLED true
  '';

  # `subPackages` keeps the built binaries to cmd/bindery, but the builder
  # derives the test scope from it as well, while the meaningful tests live in
  # internal/*. Unsetting it for the check phase lets the test phase cover the
  # whole module. Dropping -trimpath keeps testdata resolvable from the source
  # tree.
  preCheck = ''
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    unset subPackages
  '';

  # Handed to `go test` by buildGoModule, which also passes -vet=off and -p.
  # The tests listed in `skippedTests` above cannot pass offline.
  checkFlags = [ "-skip=${skipTestsRegex}" ];

  passthru = {
    inherit webui;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Automated ebook and audiobook manager for Usenet and torrents";
    homepage = "https://github.com/vavallee/bindery";
    changelog = "https://github.com/vavallee/bindery/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twstagg ];
    mainProgram = "bindery";
    platforms = lib.platforms.unix;
  };
}
