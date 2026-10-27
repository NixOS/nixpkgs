{
  lib,
  fetchFromGitHub,
  nodejs,
  buildNpmPackage,
  buildGo127Module,
  makeWrapper,
  bash,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGo127Module (finalAttrs: {

  pname = "gocron";
  version = "0.13.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flohoss";
    repo = "gocron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cePoirTNTb+tXJE57et9lkV4aNAvzp4w8hGWX+RdZ+c=";
  };

  gocron-web = buildNpmPackage (finalAttrsWebassets: {
    pname = "${finalAttrs.pname}-web";
    src = "${finalAttrs.src}/web";
    inherit (finalAttrs) version;

    npmDepsHash = "sha256-pDw7wtMU7DMpfpCK9wt7wVbH8s0t2U1r3gRmSj0kBLY=";

    dontNpmInstall = true;

    preBuild = ''
      npm run types
    '';

    postBuild = ''
      mv dist/ $out
    '';

  });

  vendorHash = "sha256-ML0bZX1pyqM73ttDUNeE0bcP+qcgVJW3rkGOc+4y+T4=";

  postPatch = ''
    substituteInPlace handlers/web.go \
      --replace-fail "web/assets" "${finalAttrs.gocron-web}/assets" \
      --replace-fail "web/static" "${finalAttrs.gocron-web}/static" \
      --replace-fail "web/index.html" "${finalAttrs.gocron-web}/index.html"
    substituteInPlace main.go \
      --replace-fail '"github.com/flohoss/gocron/internal/software"' "" \
      --replace-fail "software.Install()" ""
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/flohoss/gocron/internal/buildinfo.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/gocron --prefix PATH : ${
      lib.makeBinPath [
        bash
      ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "gocron-web"
    ];
  };
  passthru.tests = nixosTests.gocron;

  meta = {
    description = "Task scheduler built with Go and Vue.js.";
    homepage = "https://github.com/flohoss/gocron";
    license = lib.licenses.mit;
    mainProgram = "gocron";
    maintainers = with lib.maintainers; [
      juliusfreudenberger
    ];
  };

})
