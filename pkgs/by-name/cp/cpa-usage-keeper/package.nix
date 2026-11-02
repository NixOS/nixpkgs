{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nodejs_24,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "cpa-usage-keeper";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "Willxup";
    repo = "cpa-usage-keeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-usCeT+84CIhhAK4jIsSjiBazckKR2lc3mE2xI0KVNZQ=";
  };

  vendorHash = "sha256-kUPQ41UsZX86WNdeYGy914G3Pk/v/WcOfVw8Unb9SE4=";

  __structuredAttrs = true;

  # The SQLite driver uses mattn/go-sqlite3.
  env.CGO_ENABLED = 1;

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X cpa-usage-keeper/internal/version.Version=${finalAttrs.version}"
  ];

  # web/static.go embeds the built frontend with //go:embed all:dist.
  preBuild = ''
    rm -rf web/dist
    cp -r ${finalAttrs.passthru.frontend} web/dist
    chmod -R u+w web/dist
  '';

  postInstall = ''
    mv "$out/bin/server" "$out/bin/cpa-usage-keeper"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    frontend = buildNpmPackage {
      pname = "${finalAttrs.pname}-frontend";
      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs.src.name}/web";

      nodejs = nodejs_24;
      npmDepsHash = "sha256-Fy8eVMC+6YhSDjzsphdqu3Wg8fqQGzMWw55dayN4XMI=";

      installPhase = ''
        runHook preInstall
        cp -r dist "$out"
        runHook postInstall
      '';
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(.+)$"
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Usage statistics and quota dashboard for CLIProxyAPI";
    homepage = "https://github.com/Willxup/cpa-usage-keeper";
    changelog = "https://github.com/Willxup/cpa-usage-keeper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shgew ];
    mainProgram = "cpa-usage-keeper";
    platforms = lib.platforms.linux;
  };
})
