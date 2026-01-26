{
  fetchFromGitHub,
  fetchpatch,
  lib,
  oniguruma,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "szabodanika";
    repo = "microbin";
    rev = "v${version}";
    hash = "sha256-fsRpqSYDsuV0M6Xar2GVoyTgCPT39dcKJ6eW4YXCkQ0=";
  };

  cargoHash = "sha256-cQyb9KpmdJ2DB395Ce24JX8YcMLQn3fmeYZUo72L38s=";

  patches = [
    # Prefix some URLs with args.public_path_as_str() by PeterUpfold
    # https://github.com/szabodanika/microbin/pull/194
    # MicroBin returns wrong URLs on deployments with non-root URLs.
    (fetchpatch {
      name = "0001-fixup-explicit-urls.patch";
      url = "https://github.com/szabodanika/microbin/compare/b8a0c5490d681550d982ad02d67a1aaa0897f503..df062134cbaf3fd0ebcb67af8453a4c66844cd13.patch";
      hash = "sha256-h13FBuzu2O4AwdhRHF5EX5LaKyPeWJAcaV6SGTaYzTg=";
    })

    # Minor fixups by LuK1337
    # https://github.com/szabodanika/microbin/pull/211
    # Fixup styling, password protected and private pastas.
    (fetchpatch {
      name = "0002-minor-fixups.patch";
      url = "https://github.com/szabodanika/microbin/compare/b8a0c5490d681550d982ad02d67a1aaa0897f503..3b0c025e9b6dc1ca69269541940bdb53032a048a.patch";
      hash = "sha256-cZB/jx5d6F+C4xOn49TQ1at/Z4ov26efo9PTtWEdCHw=";
    })

    # Fix MICROBIN_ETERNAL_PASTA by SouthFox-D
    # https://github.com/szabodanika/microbin/pull/215
    # MICROBIN_ETERNAL_PASTA config doesn't work without this.
    (fetchpatch {
      name = "0003-fix-microbin-eternal-pasta.patch";
      url = "https://github.com/szabodanika/microbin/compare/b8a0c5490d681550d982ad02d67a1aaa0897f503..c7c846c64344b8d51500aa9a4b2e9a92de8d09d8.patch";
      hash = "sha256-gCio73Jt0F7YCFtQxtf6pPBDLNcyOAcfSsiyjLFzEzY=";
    })

    # Fix raw pastes returning 404 by GizmoTjaz
    # https://github.com/szabodanika/microbin/pull/218
    # Existing pastas return code 404 even when they exist.
    (fetchpatch {
      name = "0004-fix-raw-pastas-returning-404.patch";
      url = "https://github.com/szabodanika/microbin/compare/b8a0c5490d681550d982ad02d67a1aaa0897f503..e789901520824d4bf610d28923097affe85ead7d.patch";
      hash = "sha256-R47ozwu/FD1kCu5nx4Gf1cOFeLVFdS67K8RNDygwoZM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    changelog = "https://github.com/szabodanika/microbin/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      dit7ya
    ];
    mainProgram = "microbin";
  };
}
