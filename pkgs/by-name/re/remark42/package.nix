{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  pnpm_8,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:

let
  version = "1.15.0";

  # upstream repo is split into a Go backend and a pnpm frontend
  backendDir = "backend";
  frontendDir = "frontend";

  # the Remark42 UI build we want to produce is the workspace app at
  # frontend/apps/remark42, and its output is at frontend/apps/remark42/public
  frontendApp = "./apps/remark42";
  frontendPublicDir = "apps/remark42/public";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "remark42";
    rev = "v${version}";
    hash = "sha256-yd/qTRSZj0nZpgK77xP+XHyHcVXlNpyMzdfj6EbVcXQ=";
  };

  remark42-web = stdenv.mkDerivation (finalAttrs: {
    pname = "remark42-web";
    inherit version src;

    strictDeps = true;

    pnpmRoot = frontendDir;

    nativeBuildInputs = [
      nodejs
      pnpm_8
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/${frontendDir}";
      pnpm = pnpm_8;
      fetcherVersion = 3;
      hash = "sha256-E2tUZXhcufuztXS+Z//uZk9omvaPrevNbGqVd41Lwhw=";
    };

    buildPhase = ''
      runHook preBuild
      pushd "$pnpmRoot"
      pnpm --filter ${frontendApp} --fail-if-no-match run build
      popd
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/web
      cp -r "$pnpmRoot/${frontendPublicDir}/." $out/web/
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  pname = "remark42";
  inherit version src;

  strictDeps = true;

  modRoot = backendDir;

  # build the main package in ./backend/app
  subPackages = [ "app" ];

  # Embed the prebuilt web UI into the backend, producing a self-contained executable.
  # Upstream also describes producing a single binary "with everything embedded".
  # See: https://remark42.com/docs/getting-started/installation/
  preBuild = ''
    rm -rf app/cmd/web
    mkdir -p app/cmd/web
    cp -r ${remark42-web}/web/. app/cmd/web/
  '';

  # upstream includes vendored Go dependencies.
  vendorHash = null;

  # set the version string in the built binary.
  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.revision=v${version}"
  ];

  postInstall = ''
    if [ -e "$out/bin/app" ] && [ ! -e "$out/bin/remark42" ]; then
      mv "$out/bin/app" "$out/bin/remark42"
    fi

    if [ ! -e "$out/bin/remark42" ]; then
      echo "ERROR: expected $out/bin/remark42, but found:" >&2
      ls -la "$out/bin" >&2
      exit 1
    fi
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "remark42 --help";
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "Self-hosted comment engine that embeds a statically built frontend";
    homepage = "https://remark42.com/";
    license = licenses.mit;
    mainProgram = "remark42";
    platforms = platforms.unix;

    maintainers = with maintainers; [ janhencic ];
  };
})
