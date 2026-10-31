{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo127Module,
  nodejs-slim_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
  nix-update-script,
  nixosTests,
}:

let
  pnpm = pnpm_10.override { nodejs-slim = nodejs-slim_24; };
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "remark42";
    tag = "v${version}";
    hash = "sha256-pFLZMUZQVE+8kNLTGRQEXro3ElnXBX51eT4LAnWyN/I=";
  };

  remark42-web = stdenv.mkDerivation (finalAttrs: {
    pname = "remark42-web";
    inherit version src;

    strictDeps = true;

    sourceRoot = "${finalAttrs.src.name}/frontend/apps/remark42";

    nativeBuildInputs = [
      nodejs-slim_24
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
      hash = "sha256-OemJpM50bh/qolGOKyqKjoc5cn/re4LFa8ll4Hhihlo=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/web
      cp -r "public/." $out/web/

      runHook postInstall
    '';
  });
in
buildGo127Module (finalAttrs: {
  pname = "remark42";
  inherit version src;

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

  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit remark42-web;
    updateScript = nix-update-script { extraArgs = [ "--subpackage=remark42-web" ]; };
    tests = {
      inherit (nixosTests) remark42;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "remark42 --help";
        version = "v${finalAttrs.version}";
      };
    };
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
