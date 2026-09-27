{
  lib,
  stdenv,
  fetchFromGitHub,
  blas,
  lapack,
  zlib,
  zstd,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plink2";
  version = "2.0.0-a.7.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "chrchang";
    repo = "plink-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6mCUSXllfu5puG7oVHC+bAYIBwiFDienFz2r6otjkNc=";
  };

  sourceRoot = "${finalAttrs.src.name}/2.0/build_dynamic";

  buildInputs = [
    zlib
    zstd
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    blas
    lapack
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    # Use the zstd from nixpkgs instead of the vendored copy.
    "STATIC_ZSTD="
    # Without this, the makefile appends a literal `""` to the target names.
    "SFX="
  ]
  # On Darwin, the makefile defaults to the Accelerate framework.
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "BLASFLAGS=-llapacke -llapack -lcblas -lblas"
  ];

  buildFlags = [ "plink2" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 plink2 -t $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Whole genome association analysis toolset";
    homepage = "https://www.cog-genomics.org/plink/2.0/";
    downloadPage = "https://github.com/chrchang/plink-ng";
    changelog = "https://github.com/chrchang/plink-ng/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "plink2";
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
  };
})
