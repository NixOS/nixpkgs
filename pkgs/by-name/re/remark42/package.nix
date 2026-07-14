{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs-slim_22,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:

let
  pnpm = pnpm_9.override { nodejs-slim = nodejs-slim_22; };
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

    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = [
      nodejs-slim_22
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        postPatch
        ;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-wFrMoSeD87H1yfMD0jBcw60DKDeh4yjka5aWyHuQssA=";
    };

    postPatch = ''
      substituteInPlace "package.json" "apps/remark42/package.json" \
        --replace-fail "pnpm@8.15.9" "pnpm@${pnpm.version}"

      substituteInPlace "apps/remark42/package.json" \
        --replace-fail '"pnpm": "8.*"' '"pnpm": "9.*"'
    '';

    buildPhase = ''
      runHook preBuild

      pnpm --filter ./apps/remark42 --fail-if-no-match run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/web
      cp -r "apps/remark42/public/." $out/web/

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
