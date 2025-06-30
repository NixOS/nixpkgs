{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  nix-update-script,
  versionCheckHook,
  postgresqlTestHook,
  postgresql,
  defaultApiEndPoint ? "https://api.getdnote.com",
}:

buildGoModule rec {
  pname = "dnote";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "dnote";
    repo = "dnote";
    tag = "cli-v${version}";
    hash = "sha256-2vVopuFf9bx8U3+U4wznC/9nlLtan+fU5v9HUCEI1R4=";
  };

  npmDeps = fetchNpmDeps {
    inherit version src;
    pname = "${pname}-webui";
    sourceRoot = "${src.name}/pkg/server/assets";
    hash = "sha256-gUr8ptPsE7uw/F52CZi1P2L7eLgGiELEz6tI+fwAN0I=";
  };

  overrideModAttrs = oldAttrs: {
    # Do not add `npmConfigHook` to `goModules`
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  npmRoot = "pkg/server/assets";

  env = {
    DBHost = "localhost";
    DBPort = "5432";
    DBName = "test_db";
    DBUser = "postgres";
    DBPassword = "";
    DBSkipSSL = true;
    SmtpUsername = "mock-SmtpUsername";
    SmtpPassword = "mock-SmtpPassword";
    SmtpHost = "mock-SmtpHost";
    SmtpPort = 465;
    WebURL = "http://localhost:3000";
    DisableRegistration = false;
    postgresqlEnableTCP = true;
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
  ];

  tags = [
    "fts5"
  ];

  preBuild = ''
    patchShebangs .

    pushd pkg/server/assets

    ./styles/build.sh
    ./js/build.sh

    popd
  '';

  ldflags = [
    "-X github.com/dnote/dnote/pkg/server/buildinfo.Version=${version}"
    "-X github.com/dnote/dnote/pkg/cli/buildinfo.Version=${version}"
    "-X main.apiEndpoint=${defaultApiEndPoint}"
    "-X main.versionTag=${version}"
    "-X github.com/dnote/dnote/pkg/server/buildinfo.Standalone=true"
    "-X github.com/dnote/dnote/pkg/server/buildinfo.JSFiles=main.js"
    "-X github.com/dnote/dnote/pkg/server/buildinfo.CSSFiles=main.css"
  ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    mv $out/bin/cli $out/bin/dnote-cli
    mv $out/bin/migrate $out/bin/dnote-migrate
    mv $out/bin/server $out/bin/dnote-server
    mv $out/bin/templates $out/bin/dnote-templates
    mv $out/bin/watcher $out/bin/dnote-watcher
  '';

  checkFlags = [
    "-p 1"
  ];

  vendorHash = "sha256-4mP5z3ZVlHYhItRjkbXvcOxVm6PuZ6viL2GHqzCH9tA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/dnote-cli";
  versionCheckProgramArg = "version";
  # Fails on darwin:
  # panic: initializing context: initializing files: creating the dnote dir:
  #   initializing config dir: creating a directory at /var/empty/.config/dnote: mkdir /var/empty: file exists
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple command line notebook for programmers";
    homepage = "https://www.getdnote.com/";
    changelog = "https://github.com/dnote/dnote/blob/cli-v${version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = with lib.licenses; [
      gpl3Only
      agpl3Only
    ];
  };
}
