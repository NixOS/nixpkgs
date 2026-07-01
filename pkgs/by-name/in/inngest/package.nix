{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  stdenv,
  testers,
}:
let
  version = "1.34.0";
  websiteRev = "159c0ac611e85ec85ffe0a8c8bf2c4a0330bdb38";

  src = fetchFromGitHub {
    owner = "inngest";
    repo = "inngest";
    tag = "v${version}";
    hash = "sha256-DMJEhgKj2glNtJmsLc3oyDZr5H/COFLrcogcgaYiLjU=";
  };

  website = fetchFromGitHub {
    owner = "inngest";
    repo = "website";
    rev = websiteRev;
    hash = "sha256-EkTIv8jgcqzurz2M7PC6Kfh6x2Zxu7UmIhpTjlj8o88=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "inngest-ui";

    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 4;
      hash = "sha256-bt/7cpN9EXf2CZFRAaybr7pgJyInV0fdUy7Rv/UcT/I=";
    };
    pnpmRoot = "ui";

    buildPhase = ''
      runHook preBuild
      pnpm --filter dev-server-ui build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/dist
      cp -r ui/apps/dev-server-ui/dist/. $out/dist/
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "inngest";

  __structuredAttrs = true;

  vendorHash = null;

  preBuild = ''
    cp -r ${ui}/dist/. ./pkg/devserver/static/
    cp -r ${website}/. ./internal/embeddocs/website/
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/inngest
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/inngest/inngest/pkg/inngest/version.Version=${version}"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd" ];

  passthru = {
    inherit ui website websiteRev;
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "CLI and dev server for Inngest durable workflows";
    homepage = "https://github.com/inngest/inngest";
    changelog = "https://github.com/inngest/inngest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.sspl;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ kikos0 ];
    mainProgram = "inngest";
    platforms = lib.lists.remove "x86_64-darwin" lib.platforms.all;
  };
})
