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
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rtn1JqWxH+MCu102KaQ/Xjjh9D3UtPolko78YQPJFXc=";
  };

  cargoPatches = [
    # otherwise it tries to download swagger-ui at build time
    ./0001-enable-vendored-feature-for-utoipa-swagger-ui.patch
  ];

  cargoHash = "sha256-+W3yEska30ynTZyiq5AYHvFC5VSIsw6kPMazvOmVWn4=";

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
      ./0002-build-svelte-files-inside-the-current-directory.patch
      ./0003-fix-aarch64-segfault.patch
    ];

    npmDepsHash = "sha256-IYzWw1Ctz5L5R+e54t88ntYjREhaaQOwXBCAh4Th/EU=";
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
    description = "OpenID Connect Single Sign-On Identity & Access Management";
    license = lib.licenses.asl20;
    mainProgram = "rauthy";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = with lib.platforms; linux;
  };
})
