{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pnpm_8,
  nodejs_20,
  jq,
  writeScript,
}:
let
  version = "1.6.3";
  shortCommit = "9b27357";

  src = fetchFromGitHub {
    owner = "inngest";
    repo = "inngest";
    tag = "v${version}";
    hash = "sha256-6K8Tshdg0WjQ2yWMY6bLKJOzY0H+vwrLyLQvN2D4758=";
  };

  inngest-ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "inngest-ui";

    nativeBuildInputs = [
      pnpm_8
      pnpm_8.configHook
      nodejs_20
    ];

    patchPhase = ''
      cat ui/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/package.json > /dev/null
      cat ui/apps/dashboard/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/apps/dashboard/package.json > /dev/null
      cat ui/apps/dev-server-ui/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee ui/apps/dev-server-ui/package.json > /dev/null
    '';

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
      prePnpmInstall = ''
        cat package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee package.json > /dev/null
        cat apps/dashboard/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee apps/dashboard/package.json > /dev/null
        cat apps/dev-server-ui/package.json | ${jq}/bin/jq '.engines.pnpm = "8.15.9" | .packageManager = "pnpm@8.15.9"' | tee apps/dev-server-ui/package.json > /dev/null
      '';
    };
    pnpmRoot = "ui";
  });
in
buildGoModule {
  inherit version src inngest-ui;
  pname = "inngest";

  vendorHash = null;

  preBuild = ''
    go generate ./...
    cp -r ${inngest-ui}/dist/* ./pkg/devserver/static
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

  passthru.updateScript = writeScript "update-inngest" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i nu -p nushell common-updater-scripts nix-update

    # Use nix-update to update hashes of src and pnpmDeps
    nix-update --subpackage inngest-ui

    const pkg = 'pkgs/by-name/in/inngest/package.nix'

    let tags = http get https://api.github.com/repos/inngest/inngest/tags
    let newest = $tags
      | sort-by name --natural --reverse
      | first
      | str substring 0..6 commit.sha     # Shorten commit SHA

    let newSha = $newest.commit.sha

    # Update shortCommit (used in inngest --version)
    open $pkg
      | str replace --regex 'shortCommit = ".*"' $'shortCommit = "($newSha)"'
      | save $pkg -f
  '';

  meta = {
    description = "Queuing and orchestration for modern software teams";
    homepage = "https://www.inngest.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vivan ];
    mainProgram = "inngest";
    platforms = lib.platforms.all;
  };
}
