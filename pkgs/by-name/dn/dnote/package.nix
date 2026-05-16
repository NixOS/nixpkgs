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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "dnote";
    repo = "dnote";
    tag = "cli-v${version}";
    hash = "sha256-so86Pit8/JeO/qwoOCZp8gY/E/HwhiDi6nzye2AM33A=";
  };

  postPatch = ''
    # This is not used and compile error
    rm -rf pkg/e2e
  '';

  npmDeps = fetchNpmDeps {
    inherit version src;
    pname = "${pname}-webui";
    sourceRoot = "${src.name}/pkg/server/assets";
    hash = "sha256-yq55iO3Svqbjah9HdWfSicJISNEipxUkNDD1KJ7ZUhY=";
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
    mv $out/bin/server $out/bin/dnote-server
    mv $out/bin/schema $out/bin/dnote-schema
    mv $out/bin/watcher $out/bin/dnote-watcher
  '';

  checkFlags = [ "-p 1" ];

  vendorHash = "sha256-PExF+1SWcCROmthzo1e8Y7zqhW780GufYe35l0FRhxY=";

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
