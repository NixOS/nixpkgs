{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  htslib,
  zlib,
  bzip2,
  xz,
  curl,
  perl,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcftools";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "samtools";
    repo = "bcftools";
    tag = finalAttrs.version;
    hash = "sha256-ZwlrnfCUwrBpS1CfwPtw1To94ygbK4qoGeiuhkDPm2Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    python3
  ];

  buildInputs = [
    htslib
    zlib
    bzip2
    xz
    curl
  ];

  nativeCheckInputs = [
    htslib
  ];

  strictDeps = true;

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = lib.licenses.mit;
    homepage = "https://www.htslib.org/";
    changelog = "https://github.com/samtools/bcftools/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mimame ];
  };
})
