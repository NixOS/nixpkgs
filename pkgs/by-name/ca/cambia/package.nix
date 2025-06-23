{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  cargo-tauri,
  fetchpatch,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
}:
let
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "arg274";
    repo = "cambia";
    rev = "bef0975f72e15b925d881ab70d3bc556ecf4ff7f";
    hash = "sha256-4/GKvU3r4JpOKgkLgSOKEHnSoIsjgjQU6pay2deiIng=";
  };

  meta = {
    description = "Compact disc ripper log checking utility";
    homepage = "https://github.com/arg274/cambia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "cambia-frontend";
    inherit version;

    src = "${src}/web";
    npmDepsHash = "sha256-U+2YfsC4u6rJdeMo2zxWiXGM3061MKCcFl0oZt0ug6o=";

    installPhase = ''
      runHook preInstall
      cp -r build/ $out
      runHook postInstall
    '';

    meta = meta // {
      description = "Web UI for Cambia";
    };
  });
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cambia";
  inherit version src;

  cargoHash = "sha256-dNgFQiJrakdP0ynyVcak6cKU02Z5dcw2nhh9XhlWsOg=";

  cargoPatches = [
    # https://github.com/arg274/cambia/pull/5
    (fetchpatch {
      name = "cargo.lock.patch";
      url = "https://github.com/arg274/cambia/commit/b47944fbaf4e631ede25c560a4d7e684a2ad5014.patch";
      hash = "sha256-y9WkEmzBaFJ0eHWK0hVmB6+IdWespp79N9lSuteZZAI=";
    })
  ];

  postPatch = ''
    cp -r ${finalAttrs.passthru.frontend} web/build/
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "frontend"
      ];
    };
    inherit frontend;
  };

  meta = meta // {
    mainProgram = "cambia";
  };
})
