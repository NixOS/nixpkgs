{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  rustPlatform,
  openssl,
  pkgconf,
  git,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bichon";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "rustmailer";
    repo = "bichon";
    tag = finalAttrs.version;
    hash = "sha256-uJ2Ideu9phiHv8d7wSPu59tiH4wntDSGWL/sFUilD70=";
    # Bichon insists on running retrieving the Git hash in its build script.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT_HASH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  patches = [
    ./build-script-commit-hash.patch
  ];

  cargoHash = "sha256-l11G3x7ZiInptez9KrGNf685eyxwjqePGbQiQxCkwNI=";

  nativeBuildInputs = [
    pkgconf
    git
  ];

  buildInputs = [ openssl ];

  bichon-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-T7Y9QLO6ruPQ6eRqTq7NeSPkp4oBOjgd/U3PXbYzRuk=";
    };

    postBuild = ''
      pnpm build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  preBuild = ''
    mkdir -p web/dist
    cp -r ${finalAttrs.bichon-web}/* web/dist
  '';

  # As of 0.3.7, tests are failing due to upstream bugs (unrelated to nixpkgs)
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bichon";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "bichon-web"
    ];
  };

  meta = {
    description = "A lightweight, high-performance Rust email archiver with WebUI";
    homepage = "https://github.com/rustmailer/bichon";
    mainProgram = "bichon";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      tmarkus
    ];
  };
})
