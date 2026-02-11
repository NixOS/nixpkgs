{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs_22,
  pnpm_8,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:

let
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "remark42";
    tag = "v${version}";
    hash = "sha256-yd/qTRSZj0nZpgK77xP+XHyHcVXlNpyMzdfj6EbVcXQ=";
  };

  remark42-web = stdenv.mkDerivation (finalAttrs: {
    pname = "remark42-web";
    inherit version src;

    strictDeps = true;

    pnpmRoot = "frontend";

    nativeBuildInputs = [
      nodejs_22
      pnpm_8
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      pnpm = pnpm_8;
      fetcherVersion = 3;
      hash = "sha256-E2tUZXhcufuztXS+Z//uZk9omvaPrevNbGqVd41Lwhw=";
    };

    buildPhase = ''
      runHook preBuild
      pushd "$pnpmRoot"
      pnpm --filter ./apps/remark42 --fail-if-no-match run build
      popd
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/web
      cp -r "$pnpmRoot/apps/remark42/public/." $out/web/
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  pname = "remark42";
  inherit version src;

  strictDeps = true;

  modRoot = "backend";

  # build the main package in ./backend/app
  subPackages = [ "app" ];

  preBuild = ''
    rm -rf app/cmd/web
    mkdir -p app/cmd/web
    cp -r ${remark42-web}/web/. app/cmd/web/
  '';

  vendorHash = null;

  # set the version string in the built binary.
  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.revision=v${version}"
  ];

  postInstall = ''
    mv "$out/bin/app" "$out/bin/remark42"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "remark42 --help";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Self-hosted comment engine that embeds a statically built frontend";
    homepage = "https://remark42.com/";
    license = lib.licenses.mit;
    mainProgram = "remark42";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ janhencic ];
  };
})
