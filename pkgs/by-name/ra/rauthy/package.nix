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
  version = "0.32.6";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jww2HedX7Inr2Ek0QHyktLVIxmxMLd1lzCU72G7Yj54=";
  };

  cargoHash = "sha256-pUPLcLyTf7ZAwlWj52MiUTZ2vvendReRroazR3maeXM=";

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
    cp -r ${finalAttrs.passthru.frontend}/lib/node_modules/frontend/dist/templates/html/ templates/html
    cp -r ${finalAttrs.passthru.frontend}/lib/node_modules/frontend/dist/static/ static
  '';

  # tests take long, require the app and a database to be running, and some of them fail
  doCheck = false;

  passthru = {
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

      npmDepsHash = "sha256-2pGOR4Tc3MFqdPTFlSv+Yq9fFbpBdYmLADIYy3CS5bU=";
    };

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
