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
  version = "0.14.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flohoss";
    repo = "gocron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wd0KJoYMOx/Zi9/W+7/FVlq18GbSu46djzxnOT1HgWU=";
  };

  gocron-web = buildNpmPackage (finalAttrsWebassets: {
    pname = "${finalAttrs.pname}-web";
    src = "${finalAttrs.src}/web";
    inherit (finalAttrs) version;

    npmDepsHash = "sha256-iBoiL7E6W/jKHTCV5yoGbS+S6oJPfFZtVAboeKVYuU4=";

    dontNpmInstall = true;

    preBuild = ''
      npm run types
    '';

    postBuild = ''
      mv dist/ $out
    '';

  });

  vendorHash = "sha256-iYSeisqsHKJpJRf0kyweEu4iWVhQuxr2z9cshlEESs4=";

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
