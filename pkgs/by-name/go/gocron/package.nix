{
  lib,
  fetchFromGitHub,
  nodejs,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  stdenv,
  buildGoModule,
  makeWrapper,
  bash,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {

  pname = "gocron";
  version = "0.9.14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flohoss";
    repo = "gocron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LKjK5V+WrzTJlWPytafy8Ypva41RW4/12aSGaJj572I=";
  };

  gocron-web = stdenv.mkDerivation (finalAttrsWebassets: {
    pname = "${finalAttrs.pname}-web";
    src = "${finalAttrs.src}/web";
    inherit (finalAttrs) version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrsWebassets.src + "/yarn.lock";
      hash = "sha256-f0xnF9gd3c0KPrORPVkApyWPy+DazyzHeQu32wWybiw=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      yarnInstallHook
      nodejs
    ];

    preBuild = ''
      yarn types
    '';

    postBuild = ''
      mv dist/ $out
    '';

  });

  vendorHash = "sha256-VbmS9Fh0pr/dUB+pZBqKbi4bu6Do/3TRr9uI3TmGsOM=";

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
