{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  fetchPnpmDeps,
  makeWrapper,
  nixosTests,
  nix-update-script,
  nodejs,
  pkg-config,
  pnpm_10,
  pnpmConfigHook,
  testers,
  vips,
}:

buildGoModule (finalAttrs: {
  pname = "pronounscc";
  version = "0-unstable-2026-06-05";

  __structuredAttrs = true;
  strictDeps = true;

  # pnpmConfigHook is needed for the frontend build, but must not run while
  # buildGoModule is creating its separate Go vendor derivation.
  overrideModAttrs = _: {
    dontPnpmConfigure = true;
    preBuild = "";
  };

  outputs = [
    "out"
    "doc"
  ];

  # Latest tag is v0.6.4 (2025-09); main is ahead, so track commit on main branch.
  src = fetchFromCodeberg {
    owner = "pronounscc";
    repo = "pronouns.cc";
    rev = "e4a83a8534abf160d6c280b1706ef770a62670bb";
    hash = "sha256-qAorGWCUNRATtLgHw7EjDAP7DtNwLqAfev0K+Ncy8M8=";
  };

  vendorHash = "sha256-trnua0ZdHgLEGhPAh8nqeLF9uGJDZvQsC/YaB4ByPM0=";
  proxyVendor = true;

  pnpmWorkspaces = [ "pronouns-fe" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpmWorkspaces = [ "pronouns-fe" ];
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-y+r5kzAPg1MFmRWF7ZlLsrE2lK8zDW5c6RtSEJvqdnY=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pkg-config
    pnpm_10
    pnpmConfigHook
  ];
  buildInputs = [ vips ];

  env = {
    CGO_ENABLED = 1;
    NODE_ENV = "production";
    # SvelteKit build-time public/private env stubs.  Public values are
    # compiled into the frontend; empty values intentionally make API/media
    # URLs same-origin
    PUBLIC_BASE_URL = "";
    PUBLIC_HCAPTCHA_SITEKEY = "";
    PUBLIC_MEDIA_URL = "";
    PUBLIC_SHORT_BASE = "";
    PRIVATE_ASSETS_PREFIX = "";
    PRIVATE_SENTRY_DSN = "";
  };

  postPatch = ''
    substituteInPlace frontend/svelte.config.js \
      --replace-fail 'child_process.execSync("git describe --tags --long --always").toString().trim()' '"${finalAttrs.version}"'

    substituteInPlace scripts/{cleandb,migrate,seeddb,snowflakes}/main.go \
      --replace-fail $'err := godotenv.Load()\n\tif err != nil {' \
                     $'err := godotenv.Load()\n\tif err != nil && !os.IsNotExist(err) {'
  '';

  preBuild = ''
    go generate ./...
    pnpm --dir frontend build
  '';

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/pronounscc/pronouns.cc/backend/server.Revision=${
      lib.substring 0 7 finalAttrs.src.rev
    }"
    "-X codeberg.org/pronounscc/pronouns.cc/backend/server.Tag=${finalAttrs.version}"
  ];

  postInstall = ''
    pnpm --filter pronouns-fe --prod deploy --offline \
      --config.inject-workspace-packages=true frontend-deploy

    install -d "$out/share/pronounscc/frontend"
    cp -r frontend-deploy/{build,node_modules,package.json} \
      "$out/share/pronounscc/frontend/"
    makeWrapper ${lib.getExe nodejs} $out/bin/pronounscc-frontend \
      --add-flags "$out/share/pronounscc/frontend/build/index.js" \
      --chdir "$out/share/pronounscc/frontend" \
      --set NODE_ENV production

    install -Dm644 LICENSE $out/share/licenses/pronounscc/LICENSE
    install -Dm644 README.md docs/self-hosting.md -t $doc/share/doc/pronounscc
    install -Dm644 docs/config-examples/* -t $doc/share/doc/pronounscc/config-examples
  '';

  passthru = {
    tests = {
      inherit (nixosTests) pronounscc;
      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch=main" ];
    };
  };

  meta = {
    description = "Website for sharing names and pronouns";
    longDescription = ''
      pronouns.cc lets users create shareable pages listing their names,
      pronouns, and related preferences. This package builds the Go backend
      and SvelteKit frontend together.
    '';
    homepage = "https://codeberg.org/pronounscc/pronouns.cc";
    changelog = "https://codeberg.org/pronounscc/pronouns.cc/commits/branch/main";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "pronouns.cc";
    platforms = lib.platforms.linux;
  };
})
