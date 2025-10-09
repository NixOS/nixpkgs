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
  version = "0.32.5";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VrQ2GABWs+n7M01cLASSAkzWkqE1kAeFK+jCk5orl90=";
  };

  cargoHash = "sha256-GRIHC8sKHL8szT5YWb8uVS8VuIOQW9LGvXlU/rUfqcg=";

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

    npmDepsHash = "sha256-I5R+9Xb5G8w/rxsuEBJE0DfPi7TXC0o0S0ZbTWJGFNY=";
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
