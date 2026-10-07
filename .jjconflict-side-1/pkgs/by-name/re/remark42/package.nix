{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nodejs-slim_22,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:

let
  pnpm = pnpm_10.override { nodejs-slim = nodejs-slim_22; };
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "remark42";
    tag = "v${version}";
    hash = "sha256-VCFpN/8GRziD7sKVw7jK33llo0AGqygW4ghHZxrluJc=";
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
        ;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-PInNiI8hcXzQoYWtHUy6BTQKgII7rHzlbSGFc+ixz7k=";
    };

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
