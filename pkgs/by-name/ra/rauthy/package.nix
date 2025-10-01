{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  jemalloc,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rauthy";
  version = "0.32.4";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bGBSwv2js9Bu8n904cIM5jwZwjXugoUkYSqL/5tbDeU=";
  };

  cargoHash = "sha256-SUGmGWpJz1+gtie/jCZ7Ajt7jBtc5f1hZyaYXV8xgPY=";

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
    jemalloc
  ];

  buildInputs = [
    openssl
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/lib/node_modules/frontend/dist/templates/html/ templates/html
    cp -r ${finalAttrs.frontend}/lib/node_modules/frontend/dist/static/ static
  '';

  # tests take long, require the app and a database to be running, and some of them fail
  doCheck = false;

  frontend = buildNpmPackage {
    pname = "rauthy-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    patches = [
      # otherwise permission denied error for trying to write outside of the build directory
      ./0001-build-svelte-files-inside-the-current-directory.patch
    ];

    patchFlags = [
      "-p2"
    ];

    npmDepsHash = "sha256-khkHAkz6p6i9/b5ITKQMrSz2kyOPFHEBSAJY78j8Y+I=";
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/sebadob/rauthy/releases/tag/v${finalAttrs.version}";
    description = "Single Sign-On Identity & Access Management via OpenID Connect, OAuth 2.0 and PAM";
    license = lib.licenses.asl20;
    mainProgram = "rauthy";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = with lib.platforms; linux;
  };
})
