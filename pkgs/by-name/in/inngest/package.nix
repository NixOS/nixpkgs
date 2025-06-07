{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pnpm_8,
  nodejs_20,
  jq,
}:
let
  version = "1.6.3";
  shortCommit = "9b27357";

  patch = ''
    cat ui/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/package.json > /dev/null
    cat ui/apps/dashboard/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/apps/dashboard/package.json > /dev/null
    cat ui/apps/dev-server-ui/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/apps/dev-server-ui/package.json > /dev/null
  '';

  src = fetchFromGitHub {
    owner = "inngest";
    repo = "inngest";
    tag = "v${version}";
    hash = "sha256-6K8Tshdg0WjQ2yWMY6bLKJOzY0H+vwrLyLQvN2D4758=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "inngest-ui";

    nativeBuildInputs = [
      pnpm_8
      pnpm_8.configHook
      nodejs_20
    ];

    patchPhase = patch;

    buildPhase = ''
      cd ui/apps/dev-server-ui && pnpm build
    '';

    installPhase = ''
      mkdir -p $out
      cp -r dist $out
      cp -r .next/routes-manifest.json $out/dist
    '';

    pnpmWorkspaces = [ "dev-server-ui" ];

    pnpmDeps = pnpm_8.fetchDeps {
      inherit (finalAttrs) pname pnpmWorkspaces;
      inherit version src;
      hash = "sha256-WGZK/93WJiXryvLyGLadJ/QlHxK1p8PM53JVOXL6uq0=";
      sourceRoot = "${finalAttrs.src.name}/ui";
      prePnpmInstall = patch;
    };
    pnpmRoot = "ui";
  });
in
buildGoModule {
  inherit version src;
  pname = "inngest";

  vendorHash = null;

  preBuild = ''
    go generate ./...
    cp -r ${ui}/dist/* ./pkg/devserver/static
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/inngest
  '';

  ldflags = [
    "-s -w"
    "-X github.com/inngest/inngest/pkg/inngest/version.Version=${version}"
    "-X github.com/inngest/inngest/pkg/inngest/version.Hash=${shortCommit}"
  ];

  # The Inngest CI/CD uses GoReleaser to build the package, and the env `CGO_ENABLED` is set in the configuration file for GoReleaser
  # https://github.com/inngest/inngest/blob/main/.goreleaser.yml#L9
  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/" ];

  meta = {
    description = "Queuing and orchestration for modern software teams";
    homepage = "https://www.inngest.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vivan ];
    mainProgram = "inngest";
    platforms = lib.platforms.all;
  };
}
